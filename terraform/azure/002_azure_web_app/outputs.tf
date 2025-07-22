
output "sql_server_pwd" {
  description = "SQL Server administrator password"
  value       = random_password.db_password.result
  sensitive   = true
}

output "sql_server_admin_pwd" {
  description = "SQL Server administrator password stored in Key Vault"
  value       = azurerm_key_vault_secret.db_password.value
  sensitive   = true
}

output "dmz_vm_ip" {
  description = "Public IP address of the DMZ landing VM"
  value       = azurerm_public_ip.dmz_landing.ip_address
}

output "dmz_vm_admin_private_key" {
  description = "SSH private"
  value       = tls_private_key.dmz_landing_ssh_key.private_key_openssh
  sensitive   = true
}

output "dmz_vm_admin_public_key" {
  description = "SSH public key for the DMZ landing VM"
  value       = tls_private_key.dmz_landing_ssh_key.public_key_openssh
}

output "sql_server_ip" {
  description = "Private IP address of the SQL Server"
  value       = data.azurerm_network_interface.sql_nic.private_ip_address
}

output "webapp_url" {
  description = "URL of the Azure Web App"
  value       = azurerm_linux_web_app.web_app.default_hostname
}

output "redis_cache_host" {
  description = "Hostname of the Redis Cache"
  value       = azurerm_redis_cache.redis_cache.hostname
}

output "redis_cache_port" {
  description = "Port of the Redis Cache"
  value       = azurerm_redis_cache.redis_cache.ssl_port
}
