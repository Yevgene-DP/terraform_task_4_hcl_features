# Віртуальні машини з використанням count
resource "azurerm_virtual_machine" "main" {
  count                 = var.vm_count
  name                  = "${var.resource_group_name}-${local.vm_names[count.index]}"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = [azurerm_network_interface.main[count.index == 0 ? "nic-1" : "nic-2"].id]
  vm_size               = "Standard_B1s"
  tags                  = merge(local.common_tags, { 
    VMName = local.vm_names[count.index],
    Index  = count.index 
  })

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "osdisk-${count.index + 1}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "vm-${count.index + 1}"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  # Блок життєвого циклу для запобігання випадковому видаленню
  lifecycle {
    prevent_destroy = false
    # ignore_changes = [tags] # Розкоментуйте, якщо потрібно ігнорувати зміни тегів
  }

  # Provisioner для встановлення Nginx
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]

    connection {
      type     = "ssh"
      user     = var.admin_username
      password = var.admin_password
      host     = azurerm_public_ip.main[count.index].ip_address
    }
  }
}