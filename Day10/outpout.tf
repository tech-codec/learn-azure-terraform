output "rgname" {
  value = azurerm_resource_group.example[*].name
}

output "storage_name" {
  value = [for s in azurerm_storage_account.example : s.name]
}

output "env" {
  value = var.environment
}

output "demo" {
  value = [for item in local.nsg_rules : {
    priority    = item.priority
    description = item.description
  }]
}

output "splat" {
  value = local.nsg_rules[*].allow_http.description
}