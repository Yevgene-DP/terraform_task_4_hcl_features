# Ім'я віртуальної машини у верхньому регістрі
output "vm_names_uppercase" {
  description = "Імена віртуальних машин у верхньому регістрі"
  value       = [for vm in azurerm_virtual_machine.main : upper(vm.name)]
}

# Об'єднання значень тегів в один рядок
output "combined_tags" {
  description = "Об'єднані значення тегів"
  value       = join(", ", [for k, v in local.common_tags : "${k}=${v}"])
}

# ID всіх віртуальних машин з використанням циклу for
output "all_vm_ids" {
  description = "ID всіх віртуальних машин"
  value       = { for i, vm in azurerm_virtual_machine.main : vm.name => vm.id }
}

# Публічні IP-адреси всіх віртуальних машин
output "public_ip_addresses" {
  description = "Публічні IP-адреси віртуальних машин"
  value       = { for i, pip in azurerm_public_ip.main : azurerm_virtual_machine.main[i].name => pip.ip_address }
}

# Інформація про підключення SSH
output "ssh_connections" {
  description = "SSH connection strings"
  value       = { for i, vm in azurerm_virtual_machine.main : vm.name => "ssh ${var.admin_username}@${azurerm_public_ip.main[i].ip_address}" }
  sensitive   = true
}

# URL для доступу до Nginx
output "nginx_urls" {
  description = "URL для доступу до Nginx"
  value       = { for i, vm in azurerm_virtual_machine.main : vm.name => "http://${azurerm_public_ip.main[i].ip_address}" }
}

# Статус всіх віртуальних машин
output "vm_statuses" {
  description = "Статуси віртуальних машин"
  value       = { for vm in azurerm_virtual_machine.main : vm.name => vm.id } # Замініть на реальний статус, якщо доступний
}