variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "object_id" {
  description = "Object ID of the user for SQL Server AD admin"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "key_vault_name" {
  description = "Name of the Azure Key Vault"
  type        = string
}

variable "service_plan_name" {
  description = "Name of the Azure App Service Plan"
  type        = string
}

variable "web_app_name" {
  description = "Name of the Azure Web App"
  type        = string
}

variable "sql_server_name" {
  description = "Name of the Azure SQL Server"
  type        = string
}

variable "sql_db_name" {
  description = "Name of the Azure SQL Database"
  type        = string
}

variable "redis_cache_name" {
  description = "Name of the Azure Redis Cache"
  type        = string
}

variable "app_insights_name" {
  description = "Name of the Azure Application Insights"
  type        = string
}

variable "log_analytics_name" {
  description = "Name of the Azure Log Analytics Workspace"
  type        = string

}

variable "vnet_name" {
  description = "Name of the Azure Virtual Network"
  type        = string
}

variable "vnet_address_spaces" {
  description = "Address space for the Azure Virtual Network"
  type        = list(string)
}

variable "subnet_name" {
  description = "Name of the subnet in the Azure Virtual Network"
  type        = string
}

variable "subnet_address_prefixes" {
  description = "Address prefix for the subnet in the Azure Virtual Network"
  type        = list(string)
}

variable "sql_server_admin_username" {
  description = "Administrator username for the SQL Server"
  type        = string
}

variable "sql_server_pe_name" {
  description = "Name of the SQL Server's private endpoint"
  type        = string
}

variable "subnet_storage_name" {
  description = "Name of the storage subnet in the Azure Virtual Network"
  type        = string
}

variable "subnet_storage_address_prefixes" {
  description = "Address prefix for the storage subnet in the Azure Virtual Network"
  type        = list(string)
}

variable "redis_pe_name" {
  description = "Name of the Redis Cache's private endpoint"
  type        = string
}

variable "subnet_dmz_name" {
  description = "Name of the DMZ subnet in the Azure Virtual Network"
  type        = string
}

variable "subnet_dmz_address_prefixes" {
  description = "Address prefix for the DMZ subnet in the Azure Virtual Network"
  type        = list(string)
}

variable "dmz_landing_vm_size" {
  description = "Size of the DMZ landing VM"
  type        = string
}

variable "dmz_landing_vm_name" {
  description = "Name of the DMZ landing VM"
  type        = string
}

variable "dmz_landing_vm_admin_username" {
  description = "Admin username for the DMZ landing VM"
  type        = string
}

variable "subnet_cache_name" {
  description = "Name of the Redis Cache subnet in the Azure Virtual Network"
  type        = string
}

variable "subnet_cache_address_prefixes" {
  description = "Address prefix for the Redis Cache subnet in the Azure Virtual Network"
  type        = list(string)
}

variable "dmz_landing_authorized_ip_addresses" {
  description = "List of authorized IP addresses for SSH access to the DMZ landing VM"
  type        = list(string)
}

variable "webapp_action_group_name" {
  description = "Name of the action group for alerts"
  type        = string
}

variable "webapp_action_group_short_name" {
  description = "Short name of the action group for alerts"
  type        = string
}
