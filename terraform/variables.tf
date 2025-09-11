variable "resource_group_name" {
  description = "The name of the existing resource group to deploy into."
  type        = string
}

variable "subscription_id" {
  description = "The Azure Subscription ID."
  type        = string
}

variable "admin_username" {
  description = "The admin username for the virtual machine."
  type        = string
}

variable "admin_password" {
  description = "The admin password for the virtual machine."
  type        = string
  sensitive   = true
}

variable "ssh_source_address_prefix" {
  description = "The IP address or CIDR range to allow SSH access from."
  type        = string
  default     = "*"
}

variable "vm_name" {
  description = "The name of the virtual machine."
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machine."
  type        = string
  default     = "Standard_B2s"
}

variable "location" {
  description = "The Azure region to deploy resources into."
  type        = string
}

variable "vm_public_ip" {
  description = "The public IP address of the virtual machine."
  type        = string
}