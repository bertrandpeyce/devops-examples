# Génération automatique du mot de passe
resource "random_password" "db_password" {
  length  = 16
  special = true
}

# Stockage dans Key Vault
resource "azurerm_key_vault_secret" "db_password" {
  name         = "db-pwd"
  value        = random_password.db_password.result
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

resource "azurerm_mssql_server" "sql_server" {
  name                          = var.sql_server_name
  resource_group_name           = data.azurerm_resource_group.rg.name
  location                      = data.azurerm_resource_group.rg.location
  version                       = "12.0"
  administrator_login           = var.sql_server_admin_username
  administrator_login_password  = azurerm_key_vault_secret.db_password.value
  public_network_access_enabled = false
}

resource "azurerm_mssql_database" "sql_db" {
  name         = var.sql_db_name
  server_id    = azurerm_mssql_server.sql_server.id
  sku_name     = "S1"
  license_type = "BasePrice"
  max_size_gb  = 10
  lifecycle {
    prevent_destroy = false
  }
}


resource "azurerm_private_endpoint" "sql_pe" {
  name                = var.sql_server_pe_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  subnet_id = azurerm_subnet.storage.id

  private_dns_zone_group {
    name                 = "sql-pe-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.storage.id]
  }

  private_service_connection {
    name                           = "sql-db-connection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mssql_server.sql_server.id
    subresource_names              = ["sqlServer"]
  }

  depends_on = [azurerm_private_dns_zone.storage]
}

data "azurerm_network_interface" "sql_nic" {
  name                = azurerm_private_endpoint.sql_pe.network_interface[0].name
  resource_group_name = data.azurerm_resource_group.rg.name
}
