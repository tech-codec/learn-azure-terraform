resource "azurerm_network_security_group" "example" {
  name                = "${var.resource_name_prefix}-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dynamic "security_rule" {
    for_each = local.nsg_rules
    content {
      name                       = security_rule.key
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = security_rule.value.access
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = "*"
    }
  }
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.resource_name_prefix}-vnet"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = [var.network_address_spaces[0]]

  tags = local.Common_tags
}

resource "azurerm_subnet" "subnet1" {
  name             = "${var.resource_name_prefix}-Application-subnet"
  address_prefixes = [var.network_address_spaces[1]]
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
}

resource "azurerm_subnet" "subnet2" {
  name             = "${var.resource_name_prefix}-Management-subnet"
  address_prefixes = [var.network_address_spaces[2]]
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
}

resource "azurerm_subnet_network_security_group_association" "vmss_nsg" {
  for_each = local.nsg_subnets
  subnet_id                 = each.value
  network_security_group_id = azurerm_network_security_group.example.id
}