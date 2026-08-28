output "vic_id" {
  value = local.vm_instance
}

output "size_vnet" {
  value = length(azurerm_virtual_network.vnet[*])
}