# Virtual machines using for_each (attached to NICs created with for_each)
resource "azurerm_linux_virtual_machine" "for_each_vms" {
  for_each                        = toset(local.nic_names_list) # Fixed: using local.nic_names_list
  name                            = "${local.base_name}-vm-${replace(each.value, "nic", "vm")}"
  location                        = azurerm_resource_group.main.location
  resource_group_name             = azurerm_resource_group.main.name
  size                            = "Standard_B1s"
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nic_instances[each.value].id]
  tags                            = merge(local.common_tags, { Instance = each.value })

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