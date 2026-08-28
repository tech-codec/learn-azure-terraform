output "rgname" {
  value = azurerm_resource_group.example[*].name
}

output "storage_name" {
  value = [for s in azurerm_storage_account.example : s.name]
}