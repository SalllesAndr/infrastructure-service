resource "azurerm_container_registry" "acr" {
  name                = "feedbacktsystemsapp"
  resource_group_name = azurerm_resource_group.production.name
  location            = azurerm_resource_group.production.location
  sku                 = "Premium"
  admin_enabled       = true
}

resource "azurerm_container_registry" "acr_user" {
  name                = "usertsystemsapp"
  resource_group_name = azurerm_resource_group.production.name
  location            = azurerm_resource_group.production.location
  sku                 = "Premium"
  admin_enabled       = true
}
