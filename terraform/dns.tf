resource "azurerm_dns_zone" "cloudt" {
  name                = "cloudt.com.br"
  resource_group_name = azurerm_resource_group.production.name
}

resource "azurerm_dns_cname_record" "user" {
  name                = "user"
  zone_name           = azurerm_dns_zone.cloudt.name
  resource_group_name = azurerm_resource_group.production.name
  ttl                 = 300
  record              = azurerm_linux_web_app.feedback.default_hostname
}

resource "azurerm_dns_cname_record" "feedback" {
  name                = "feedback"
  zone_name           = azurerm_dns_zone.cloudt.name
  resource_group_name = azurerm_resource_group.production.name
  ttl                 = 300
  record              = azurerm_linux_web_app.feedback.default_hostname
}

resource "azurerm_dns_cname_record" "site" {
  name                = "www"
  zone_name           = azurerm_dns_zone.cloudt.name
  resource_group_name = azurerm_resource_group.production.name
  ttl                 = 300
  record              = var.site_hostname
}
