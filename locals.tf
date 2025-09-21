locals {
  # Список імен мережевих інтерфейсів для for_each
  nic_names = {
    "nic-1" = "${var.resource_group_name}-nic-1"
    "nic-2" = "${var.resource_group_name}-nic-2"
    "nic-3" = "${var.resource_group_name}-nic-3"
  }

  # Правила мережевої безпеки
  nsg_rules = [
    {
      name                       = "SSH"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "HTTP"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "HTTPS"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]

  # Теги для ресурсів
  common_tags = {
    Environment = var.environment
    CreatedBy   = "Terraform"
    Project     = "Multi-VM Deployment"
  }

  # Імена віртуальних машин з використанням count
  vm_names = [for i in range(var.vm_count) : "vm-${i + 1}"]
}