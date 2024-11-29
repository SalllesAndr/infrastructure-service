terraform {
  backend "azurerm" {
    resource_group_name  = "terraformtfstate"
    storage_account_name = "tfstatetsystemsfeedback"
    container_name       = "terraformtfstate"
    key                  = "terraform.tfstate"
  }
}
