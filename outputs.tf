# Output with uppercase VM name transformation (includes both count and for_each VMs)
output "vm_names_uppercase" {
  description = "VM names converted to uppercase"
  value = concat(
    [for vm in azurerm_linux_virtual_machine.main : upper(vm.name)],
    [for vm in azurerm_linux_virtual_machine.for_each_vms : upper(vm.name)]
  )
}

# Output combining multiple tag values into one string
output "combined_tags" {
  description = "Combined tag values as a single string"
  value       = join(", ", [for key, value in local.common_tags : "${key}:${value}"])
}

# Output using for loop to get all VM IDs (as a simple list)
output "all_vm_ids" {
  description = "List of all VM resource IDs"
  value = concat(
    [for vm in azurerm_linux_virtual_machine.main : vm.id],
    [for vm in azurerm_linux_virtual_machine.for_each_vms : vm.id]
  )
}

# Output public IP addresses
output "vm_public_ips" {
  description = "Public IP addresses of VM instances"
  value       = { for i, ip in azurerm_public_ip.vm_instances : "vm-${i}" => ip.ip_address }
  sensitive   = false
}

# Output network interface information
output "network_interfaces" {
  description = "Network interface details"
  value       = { for nic in azurerm_network_interface.nic_instances : nic.key => nic.value.name }
}