
resource "archive_file" "web_app_zip" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/app.zip"
}

resource "azurerm_service_plan" "service_plan" {
  name                = var.service_plan_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "P1v2"
}

resource "azurerm_linux_web_app" "web_app" {
  name                = var.web_app_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.service_plan.id

  public_network_access_enabled = true

  site_config {
    application_stack {
      node_version = "20-lts"
    }
  }
  app_settings = {
    "DB_NAME"                               = azurerm_mssql_database.sql_db.name
    "DB_USER"                               = azurerm_mssql_server.sql_server.administrator_login
    "DB_PASSWORD"                           = azurerm_mssql_server.sql_server.administrator_login_password
    "DB_SERVER"                             = azurerm_mssql_server.sql_server.fully_qualified_domain_name
    "NODE_ENV"                              = "production"
    "REDIS_HOST"                            = azurerm_redis_cache.redis_cache.hostname
    "REDIS_PORT"                            = azurerm_redis_cache.redis_cache.ssl_port
    "REDIS_PASSWORD"                        = azurerm_redis_cache.redis_cache.primary_access_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = azurerm_application_insights.insight.connection_string
    "SCM_DO_BUILD_DURING_DEPLOYMENT"        = "true"
    "ENABLE_ORYX_BUILD"                     = "true"
    "PORT"                                  = 8080
  }
  identity {
    type = "SystemAssigned"
  }
  zip_deploy_file = archive_file.web_app_zip.output_path

  logs {
    detailed_error_messages = true
    failed_request_tracing  = true

    application_logs {
      file_system_level = "Verbose" # Plus de détails
    }

    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 35
      }
    }
  }

}

resource "azurerm_app_service_virtual_network_swift_connection" "example" {
  app_service_id = azurerm_linux_web_app.web_app.id
  subnet_id      = azurerm_subnet.subnet.id
  depends_on = [
    azurerm_linux_web_app.web_app,
    azurerm_subnet.subnet
  ]
}

resource "azurerm_key_vault_access_policy" "web_app_access" {
  key_vault_id       = data.azurerm_key_vault.key_vault.id
  tenant_id          = data.azurerm_key_vault.key_vault.tenant_id
  object_id          = azurerm_linux_web_app.web_app.identity[0].principal_id
  secret_permissions = ["Get"]
}

resource "azurerm_redis_cache_access_policy_assignment" "web_app_cache_assignment" {
  name               = "redis-access-policy"
  redis_cache_id     = azurerm_redis_cache.redis_cache.id
  access_policy_name = azurerm_redis_cache_access_policy.cache_contributor.name
  object_id          = azurerm_linux_web_app.web_app.identity[0].principal_id
  object_id_alias    = "WebAppPayment"
}
