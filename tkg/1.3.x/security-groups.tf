resource "azurerm_network_security_group" "jump-server" {
  name                = var.azure_jump_server_nsg_name
  location            = azurerm_resource_group.tanzu-resource-group.location
  resource_group_name = azurerm_resource_group.tanzu-resource-group.name

  security_rule {
    name                       = "allow_ssh"
    priority                   = 2200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "control-plane" {
  name                = var.azure_control_plane_nsg_name
  location            = azurerm_resource_group.tanzu-resource-group.location
  resource_group_name = azurerm_resource_group.tanzu-resource-group.name

  security_rule {
    name                       = "allow_ssh"
    priority                   = 2200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_apiserver"
    priority                   = 2201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "6443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "mgmt-cluster-node" {
  name                = var.azure_mgmt_cluster_node_nsg_name
  location            = azurerm_resource_group.mgmt-cluster-resource-group.location
  resource_group_name = azurerm_resource_group.mgmt-cluster-resource-group.name
}

resource "azurerm_network_security_group" "workload-cluster-node" {
  name                = var.azure_workload_cluster_node_nsg_name
  location            = azurerm_resource_group.workload-cluster-resource-group.location
  resource_group_name = azurerm_resource_group.workload-cluster-resource-group.name
}
