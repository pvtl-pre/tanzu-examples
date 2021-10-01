# Outputs

output "azure_jump_server_pip" {
  value       = azurerm_public_ip.jump-server.ip_address
  description = "The public IP address of the jump server instance."
}

# Variables

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

variable "azure_tanzu_resource_group" {
  type    = string
  default = "tanzu"
}

variable "azure_mgmt_cluster_resource_group" {
  type    = string
  default = "mgmt-cluster"
}

variable "azure_workload_cluster_resource_group" {
  type    = string
  default = "workload-cluster"
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

variable "azure_jump_server_nsg_name" {
  type    = string
  default = "jump-server-nsg"
}

variable "azure_control_plane_subnet_name" {
  type    = string
  default = "control-plane-subnet"
}

variable "azure_control_plane_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "azure_control_plane_nsg_name" {
  type    = string
  default = "control-plane-nsg"
}

variable "azure_mgmt_cluster_node_subnet_name" {
  type    = string
  default = "mgmt-cluster-node-subnet"
}

variable "azure_mgmt_cluster_node_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "azure_mgmt_cluster_node_nsg_name" {
  type    = string
  default = "mgmt-cluster-node-nsg"
}

variable "azure_workload_cluster_node_subnet_name" {
  type    = string
  default = "workload-cluster-node-subnet"
}

variable "azure_workload_cluster_node_subnet_cidr" {
  type    = string
  default = "10.0.3.0/24"
}

variable "azure_workload_cluster_node_nsg_name" {
  type    = string
  default = "workload-cluster-node-nsg"
}
