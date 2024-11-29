resource "azurerm_service_plan" "feedback" {
  name                = "feedback"
  resource_group_name = azurerm_resource_group.production.name
  location            = var.azure_backend_resources_region
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "feedback" {
  name                          = "feedback-app-tsystems"
  resource_group_name           = azurerm_resource_group.production.name
  location                      = azurerm_service_plan.feedback.location
  service_plan_id               = azurerm_service_plan.feedback.id
  public_network_access_enabled = true

  app_settings = {
    MONGO_DETAILS = var.mongo_details
    PORT          = "8000"
    API_KEY       = var.api_key
  }

  site_config {
    application_stack {
      docker_registry_url      = "https://${azurerm_container_registry.acr.login_server}"
      docker_image_name        = "feedback-service:latest"
      docker_registry_username = azurerm_container_registry.acr.admin_username
      docker_registry_password = azurerm_container_registry.acr.admin_password
    }
  }
}


resource "azurerm_dns_txt_record" "feedback_verification" {
  name                = "asuid.feedback"
  zone_name           = azurerm_dns_zone.cloudt.name
  resource_group_name = azurerm_resource_group.production.name
  ttl                 = 300

  record {
    value = azurerm_linux_web_app.feedback.custom_domain_verification_id
  }
}

resource "azurerm_app_service_custom_hostname_binding" "feedback_hostname_binding" {
  hostname            = "feedback.cloudt.com.br"
  app_service_name    = azurerm_linux_web_app.feedback.name
  resource_group_name = azurerm_resource_group.production.name

  depends_on = [azurerm_dns_cname_record.feedback, azurerm_dns_txt_record.feedback_verification]
}

resource "azurerm_app_service_managed_certificate" "feedback_managed_cert" {
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.feedback_hostname_binding.id
}

resource "azurerm_app_service_certificate_binding" "feedback_ssl_binding" {
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.feedback_hostname_binding.id
  certificate_id      = azurerm_app_service_managed_certificate.feedback_managed_cert.id
  ssl_state           = "SniEnabled"
}

resource "azurerm_linux_web_app" "user" {
  name                          = "user-app-tsystems"
  resource_group_name           = azurerm_resource_group.production.name
  location                      = azurerm_service_plan.feedback.location
  service_plan_id               = azurerm_service_plan.feedback.id
  public_network_access_enabled = true

  app_settings = {
    MONGO_DETAILS = var.mongo_details
    PORT          = "8000"
    API_KEY       = var.api_key
  }

  site_config {
    application_stack {
      docker_registry_url      = "https://${azurerm_container_registry.acr_user.login_server}"
      docker_image_name        = "user-service:latest"
      docker_registry_username = azurerm_container_registry.acr_user.admin_username
      docker_registry_password = azurerm_container_registry.acr_user.admin_password
    }
  }
}

resource "azurerm_app_service_custom_hostname_binding" "user_hostname_binding" {
  hostname            = "user.cloudt.com.br"
  app_service_name    = azurerm_linux_web_app.user.name
  resource_group_name = azurerm_resource_group.production.name

  depends_on = [azurerm_dns_cname_record.user, azurerm_dns_txt_record.user_verification]
}

resource "azurerm_app_service_managed_certificate" "user_managed_cert" {
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.user_hostname_binding.id
}

resource "azurerm_app_service_certificate_binding" "user_ssl_binding" {
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.user_hostname_binding.id
  certificate_id      = azurerm_app_service_managed_certificate.user_managed_cert.id
  ssl_state           = "SniEnabled"
}

resource "azurerm_dns_txt_record" "user_verification" {
  name                = "asuid.user"
  zone_name           = azurerm_dns_zone.cloudt.name
  resource_group_name = azurerm_resource_group.production.name
  ttl                 = 300

  record {
    value = azurerm_linux_web_app.user.custom_domain_verification_id
  }
}
