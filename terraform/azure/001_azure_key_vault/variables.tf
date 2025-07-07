variable "subscription_id" {
  description = "Azure Subscription ID"
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

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "object_id" {
  description = "Object ID of the user or service principal to grant access to the Key Vault"
  type        = string
}

variable "key_permissions" {
  description = "List of key permissions to grant in the Key Vault"
  type        = list(string)
  default = [
    "Get",
    "List",
    "Create",
    "Update",
    "Delete",
    "Purge",
    "Recover",
  ]
}

variable "secret_permissions" {
  description = "List of secret permissions to grant in the Key Vault"
  type        = list(string)
  default = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Purge",
    "Recover",
  ]
}

variable "certificate_permissions" {
  description = "List of certificate permissions to grant in the Key Vault"
  type        = list(string)
  default = [
    "Get",
    "List",
    "Create",
    "Update",
    "Delete",
    "Purge",
    "Recover",
  ]
}
