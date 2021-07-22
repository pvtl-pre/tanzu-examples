variable "myvmware_com_username" {
  type = string
}

variable "myvmware_com_password" {
  type      = string
  sensitive = true
}

variable "azure_jump_server_username" {
  type = string
}

variable "azure_jump_server_ssh_public_key_path" {
  type = string
}

variable "azure_jump_server_ssh_private_key_path" {
  type = string
}

variable "azure_location" {
  type    = string
  default = "southcentralus"
}

variable "azure_resource_group" {
  type    = string
  default = "tanzu"
}

variable "azure_vnet_name" {
  type    = string
  default = "tanzu-vnet"
}

variable "azure_vnet_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "azure_jump_server_subnet_name" {
  type    = string
  default = "jump-server-subnet"
}

variable "azure_jump_server_subnet_cidr" {
  type    = string
  default = "10.0.0.0/24"
}

variable "azure_control_plane_subnet_name" {
  type    = string
  default = "control-plane-subnet"
}

variable "azure_control_plane_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "azure_node_subnet_name" {
  type    = string
  default = "node-subnet"
}

variable "azure_node_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}
