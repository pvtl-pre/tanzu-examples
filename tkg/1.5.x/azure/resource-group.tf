resource "azurerm_resource_group" "tanzu-resource-group" {
  name     = var.azure_tanzu_resource_group
  location = var.azure_location
}

resource "azurerm_resource_group" "mgmt-cluster-resource-group" {
  name     = var.azure_mgmt_cluster_resource_group
  location = var.azure_location
}

resource "azurerm_resource_group" "workload-cluster-resource-group" {
  name     = var.azure_workload_cluster_resource_group
  location = var.azure_location
}
