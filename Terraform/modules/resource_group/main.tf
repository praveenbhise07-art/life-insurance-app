resource "azurerm_resource_group" "rg" {
  name     = var.name
  location = var.location

  tags = {
    Environment = var.environment
    Project     = "ApexShield"
    ManagedBy   = "Terraform"
  }
}