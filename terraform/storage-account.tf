resource "azurerm_storage_account" "feedback" {
  name                     = "feedbacktsystemsapp"
  resource_group_name      = azurerm_resource_group.production.name
  location                 = azurerm_resource_group.production.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
