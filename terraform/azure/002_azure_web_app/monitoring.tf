
# azure monitor
# azure sql anaytics
# query performance insight
# 

# pour sql server, webapp et cache redis
resource "azurerm_log_analytics_workspace" "workspace" {
  name                = var.log_analytics_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Utilisé pour le web app
resource "azurerm_application_insights" "insight" {
  name                = var.app_insights_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  application_type    = "Node.JS"
  workspace_id        = azurerm_log_analytics_workspace.workspace.id
}

resource "azurerm_monitor_action_group" "webapp" {
  name                = var.webapp_action_group_name
  resource_group_name = data.azurerm_resource_group.rg.name
  short_name          = var.webapp_action_group_short_name
  email_receiver {
    name          = "admin"
    email_address = "admin@yourentreprise.com"
  }
}

resource "azurerm_monitor_metric_alert" "payment_failed_alert" {
  name                = "payment-failed-alert"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [azurerm_application_insights.insight.id]
  description         = "Alert when there are more than 5 failed requests in a minute"
  window_size         = "PT5M"
  frequency           = "PT1M"
  severity            = 0
  criteria {
    metric_namespace = "Microsoft.Insights/components"
    metric_name      = "requests/failed"
    aggregation      = "Count"
    operator         = "GreaterThan"
    threshold        = 5
  }
  action {
    action_group_id = azurerm_monitor_action_group.webapp.id
  }
}

resource "azurerm_monitor_metric_alert" "payment_response_time" {
  name                = "payment-response-time-alert"
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = [azurerm_application_insights.insight.id]
  description         = "Alert when the average response time is greater than 2 seconds"
  window_size         = "PT5M"
  frequency           = "PT1M"
  severity            = 1
  criteria {
    metric_namespace = "Microsoft.Insights/components"
    metric_name      = "requests/duration"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 2000
  }
  action {
    action_group_id = azurerm_monitor_action_group.webapp.id
  }
}
