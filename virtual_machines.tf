# Virtual machines using count
resource "azurerm_linux_virtual_machine" "main" {
  count                 = var.vm_count
  name                  = "${local.base_name}-vm-${count.index}"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  size                  = "Standard_B1s"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.vm_instances[count.index].id]
  tags                  = merge(local.common_tags, { Instance = count.index })

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  # Lifecycle block to prevent accidental deletion
  lifecycle {
    prevent_destroy = true  # Changed from false to true
    ignore_changes = [
      tags
    ]
  }
}

# Virtual machines using for_each (attached to NICs created with for_each)
resource "azurerm_linux_virtual_machine" "for_each_vms" {
  for_each              = var.nic_names
  name                  = "${local.base_name}-vm-${each.key}"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  size                  = "Standard_B1s"
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.nic_instances[each.key].id]
  tags                  = merge(local.common_tags, { Instance = each.key })

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = [
      tags
    ]
  }
}