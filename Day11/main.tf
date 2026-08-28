locals {
  format_name = lower(replace(var.project_name, " ", "-"))
  merge_tags = merge(var.Environment_tags, var.Default_tags)
  splite_st_name = split(" ", var.storage_name)
  sub_st_name= replace(substr(local.splite_st_name[2], 1, 23), "?@", "")
  format_port = split(",", var.allowed_port)

  nsg_rules = [for port in local.format_port: {
    name="port-${port}"
    description = "allow-port-${port}"
    destination_port_range = port
    }]

    # vm_size = lookup(var.vm_size, var.environment, lower("dev"))
}

resource "azurerm_resource_group" "example" {
  name = "${local.format_name}-rg"
  location = "canadacentral"
  tags = local.merge_tags
}

resource "azurerm_storage_account" "example" {
  name = local.sub_st_name
  resource_group_name = azurerm_resource_group.example.name
  location = azurerm_resource_group.example.location
  account_replication_type = "LRS"
  account_tier = "Standard"
}

resource "azurerm_network_security_group" "example" {
  name = replace(var.allowed_port, ",","-port") 
  resource_group_name = azurerm_resource_group.example.name
  location = azurerm_resource_group.example.location
  dynamic "security_rule" {
    for_each = local.nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = 189
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = security_rule.value.description
    }
  }
}


output "name_rg" {
  value = azurerm_resource_group.example.name
}

output "size_st-name" {
  value = length(local.sub_st_name)
}

output "rule_nsg" {
  value = local.nsg_rules
}

output "st_name" {
  value = local.sub_st_name
}

output "vm_size" {
  value = var.vm_size
}

output "credential" {
  value = var.credential
  sensitive = true
}

output "backup_name" {
  value = var.backup_name
}

output "directory_name" {
  value = dirname(var.validate_path)
}

output "validate_path" {
  value = var.validate_path
}