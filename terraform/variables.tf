variable "azure_region" {
  description = "The Azure region to deploy resources"
  type        = string
  default     = "eastus"
}

variable "azure_backend_resources_region" {
  description = "The Azure region to deploy backend resources"
  type        = string
  default     = "Brazil South"
}

variable "mongo_details" {
  description = "The MongoDB connection string"
  type        = string
  sensitive   = true
}

variable "api_key" {
  description = "The API key to access the service"
  type        = string
  sensitive   = true
}

variable "site_hostname" {
  description = "The hostname of the site"
  type        = string
}
