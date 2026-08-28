resource "azurerm_resource_group" "example" {
  name     = "${var.environment}-resources"
  location = var.allowed_locations[0]
}

resource "azurerm_storage_account" "example" {

  for_each = var.storage_account_name
  name                     = each.value
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.environment
  }

  lifecycle{
    create_before_destroy=true

    ignore_changes = [
      tags
    ]
  }

}


resource "azurerm_network_security_group" "example" {
  name = var.environment == "dev" ? "dev-nsg" : "prod-nsg"
  resource_group_name = azurerm_resource_group.example.name
  location = azurerm_resource_group.example.location
  dynamic "security_rule" {
    for_each = local.nsg_rules
    content {
      name                       = security_rule.key
      priority                   = security_rule.value.priority
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
