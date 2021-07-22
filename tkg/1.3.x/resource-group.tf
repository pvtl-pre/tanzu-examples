resource "azurerm_resource_group" "resource-group" {
  name     = var.azure_resource_group
  location = var.azure_location
}
