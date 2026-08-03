variable "resource_group_name" {
  type        = string
  description = "Name of the Resource Group"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "environment" {
  type        = string
  description = "Deployment environment"
  default     = "dev"
}

variable "vm_size" {
  type        = string
  description = "Size of the VM"
  default     = "Standard_D2s_v3"
}

variable "admin_username" {
  type        = string
  description = "Admin username for SSH access"
  default     = "azureuser"
}

variable "ssh_public_key" {
  type        = string
  description = "Public SSH key for authentication"
}