# Network interfaces using count (for VM instances)
resource "azurerm_network_interface" "vm_instances" {
  count               = var.vm_count
  name                = "${local.base_name}-nic-vm-${count.index}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_instances[count.index].id
  }
}

# Network interfaces using for_each with local.nic_names_list
resource "azurerm_network_interface" "nic_instances" {
  for_each            = toset(local.nic_names_list) # Fixed: using local.nic_names_list
  name                = each.value
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.common_tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.nic_instances[index(local.nic_names_list, each.value)].id
  }
}

# Associate NSG with network interfaces
resource "azurerm_network_interface_security_group_association" "vm_instances" {
  count                     = var.vm_count
  network_interface_id      = azurerm_network_interface.vm_instances[count.index].id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "azurerm_network_interface_security_group_association" "nic_instances" {
  for_each                  = toset(local.nic_names_list) # Fixed: using local.nic_names_list
  network_interface_id      = azurerm_network_interface.nic_instances[each.value].id
  network_security_group_id = azurerm_network_security_group.main.id
}