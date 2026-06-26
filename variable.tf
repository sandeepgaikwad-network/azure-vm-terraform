# variables.tf

# General settings
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "project"
}

variable "environment" {
  description = "Deployment environment (dev, test, prod)"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region for deployment"
  type        = string
  default     = "South India"
}

# Networking
variable "vnet_address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_prefix" {
  description = "Subnet address prefix"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

# VM settings
variable "vm_size" {
  description = "Size of the Virtual Machine"
  type        = string
  default     = "Standard_B1s"
}

variable "admin_username" {
  description = "Admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}
