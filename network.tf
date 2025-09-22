# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${local.base_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags
}

# Subnet
resource "azurerm_subnet" "main" {
  name                 = "${local.base_name}-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IPs for each VM instance
resource "azurerm_public_ip" "vm_instances" {
  count               = var.vm_count
  name                = "${local.base_name}-pip-${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
  tags                = local.common_tags
}

# Public IPs for each network interface (for_each)
resource "azurerm_public_ip" "nic_instances" {
  for_each            = var.nic_names
  name                = "${local.base_name}-pip-${each.key}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
  tags                = local.common_tags
}

# Network Security Group with dynamic blocks
resource "azurerm_network_security_group" "main" {
  name                = "${local.base_name}-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags

  dynamic "security_rule" {
    for_each = local.nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}