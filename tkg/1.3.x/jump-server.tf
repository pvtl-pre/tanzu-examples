resource "azurerm_public_ip" "jump-server" {
  name                = "jump-server-pip"
  location            = azurerm_resource_group.tanzu-resource-group.location
  resource_group_name = azurerm_resource_group.tanzu-resource-group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "jump-server-nic" {
  name                = "jump-server-nic"
  location            = azurerm_resource_group.tanzu-resource-group.location
  resource_group_name = azurerm_resource_group.tanzu-resource-group.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = azurerm_subnet.jump-server.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.jump-server.id
  }
}

resource "azurerm_linux_virtual_machine" "jump-server" {
  name                = "jump-server"
  resource_group_name = azurerm_resource_group.tanzu-resource-group.name
  location            = azurerm_resource_group.tanzu-resource-group.location
  size                = "Standard_D2s_v3"
  admin_username      = var.azure_jump_server_username
  network_interface_ids = [
    azurerm_network_interface.jump-server-nic.id,
  ]

  admin_ssh_key {
    username   = var.azure_jump_server_username
    public_key = file(var.azure_jump_server_ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  connection {
    type        = "ssh"
    user        = "${var.azure_jump_server_username}"
    private_key = file("${var.azure_jump_server_ssh_private_key_path}")
    host        = azurerm_public_ip.jump-server.ip_address
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir clusterconfigs",
      "mkdir scripts"
    ]
  }

  provisioner "file" {
    source      = "clusterconfigs/"
    destination = "clusterconfigs"
  }

  provisioner "file" {
    source      = "jump-server-scripts/"
    destination = "scripts"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 755 scripts/*.sh",
      "scripts/docker-install.sh"
    ]
  }
}