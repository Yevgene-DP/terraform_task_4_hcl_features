resource_group_name = "rg-terraform-task-4"
location            = "West Europe"
admin_username      = "adminuser"
admin_password      = "SecurePassword123!"
vm_count            = 2

nic_names = {
  nic1 = "web-server-nic"
  nic2 = "app-server-nic"
  nic3 = "db-server-nic"
}