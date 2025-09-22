variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-terraform-task"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "West Europe"
}

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
  default     = "adminuser"
  sensitive   = true
}

variable "admin_password" {
  description = "Admin password for VMs"
  type        = string
  sensitive   = true
  default     = "Password1234!"
}

variable "vm_count" {
  description = "Number of VM instances to create"
  type        = number
  default     = 2
}

variable "nic_names" {
  description = "Map of network interface names"
  type        = map(string)
  default = {
    nic1 = "vm-nic-1"
    nic2 = "vm-nic-2"
    nic3 = "vm-nic-3"
  }
}