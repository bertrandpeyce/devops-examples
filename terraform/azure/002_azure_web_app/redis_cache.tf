
resource "azurerm_redis_cache" "redis_cache" {
  name                          = var.redis_cache_name
  location                      = data.azurerm_resource_group.rg.location
  resource_group_name           = data.azurerm_resource_group.rg.name
  capacity                      = 1
  family                        = "P"
  sku_name                      = "Premium"
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false
  identity {
    type = "SystemAssigned"
  }
  subnet_id = azurerm_subnet.cache.id
}

resource "azurerm_redis_cache_access_policy" "cache_contributor" {
  name           = "cache-contributor"
  redis_cache_id = azurerm_redis_cache.redis_cache.id
  permissions    = "+@read +@write +@connection +cluster|info"
}
