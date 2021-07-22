resource "azurerm_subnet" "jump-server" {
  name                 = var.azure_jump_server_subnet_name
  resource_group_name  = azurerm_resource_group.resource-group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.azure_jump_server_subnet_cidr]
}

resource "azurerm_subnet_network_security_group_association" "jump-server" {
  subnet_id                 = azurerm_subnet.jump-server.id
  network_security_group_id = azurerm_network_security_group.jump-server.id
}

resource "azurerm_subnet" "control-plane" {
  name                 = var.azure_control_plane_subnet_name
  resource_group_name  = azurerm_resource_group.resource-group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.azure_control_plane_subnet_cidr]
}

resource "azurerm_subnet_network_security_group_association" "control-plane" {
  subnet_id                 = azurerm_subnet.control-plane.id
  network_security_group_id = azurerm_network_security_group.control-plane.id
}

resource "azurerm_subnet" "node" {
  name                 = var.azure_node_subnet_name
  resource_group_name  = azurerm_resource_group.resource-group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.azure_node_subnet_cidr]
}

resource "azurerm_subnet_network_security_group_association" "node" {
  subnet_id                 = azurerm_subnet.node.id
  network_security_group_id = azurerm_network_security_group.node.id
}
