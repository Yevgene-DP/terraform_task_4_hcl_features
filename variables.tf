variable "resource_group_name" {
  description = "Назва групи ресурсів"
  type        = string
  default     = "tf-vm-resources"
}

variable "location" {
  description = "Регіон Azure"
  type        = string
  default     = "West Europe"
}

variable "vm_count" {
  description = "Кількість віртуальних машин для створення"
  type        = number
  default     = 2
}

variable "admin_username" {
  description = "Ім'я адміністратора"
  type        = string
  sensitive   = true
  default     = "adminuser"
}

variable "admin_password" {
  description = "Пароль адміністратора"
  type        = string
  sensitive   = true
  default     = "Password1234!"
}

variable "environment" {
  description = "Середовище (dev, staging, prod)"
  type        = string
  default     = "dev"
}