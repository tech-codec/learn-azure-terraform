resource "azurerm_virtual_network" "vnet" {
  for_each = local.vnet_department

  name = "${var.resource_name_prefix}-vnet-${each.value.name}"
  resource_group_name = azurerm_resource_group.example.name
  location = azurerm_resource_group.example.location
  address_space = each.value.address_space
}

resource "azurerm_subnet" "subnet_finance" {
  name = "${var.resource_name_prefix}-subnet-${var.tags.finance}"
  virtual_network_name = azurerm_virtual_network.vnet["vnet_finance"].name 
  resource_group_name = azurerm_resource_group.example.name
  address_prefixes = ["10.1.0.0/24"]
}

resource "azurerm_subnet" "subnet_bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.vnet["vnet_finance"].name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_subnet" "subnet_devops" {
  name = "${var.resource_name_prefix}-subnet-${var.tags.devops}"
  virtual_network_name = azurerm_virtual_network.vnet["vnet_devops"].name
  resource_group_name = azurerm_resource_group.example.name
  address_prefixes = ["10.2.0.0/24"]
}

resource "azurerm_network_interface" "nic_finance_vm" {
  
  for_each = local.nic_finance

  name = "${var.resource_name_prefix}-nic-${each.value.name}-${var.tags.finance}"
  resource_group_name = azurerm_resource_group.example.name
  location = azurerm_resource_group.example.location

  ip_configuration {
    name = "${var.resource_name_prefix}-ipc-${each.value.name}-${var.tags.finance}"
    private_ip_address_allocation = "Dynamic"
    subnet_id = each.value.subnet_id
  }
}


resource "azurerm_network_interface" "nic_devops_vm" {
  
  for_each = local.nic_devops

  name = "${var.resource_name_prefix}-nic-${each.value.name}-${var.tags.devops}"
  resource_group_name = azurerm_resource_group.example.name
  location = azurerm_resource_group.example.location

  ip_configuration {
    name = "${var.resource_name_prefix}-ipc-${each.value.name}-${var.tags.devops}"
    private_ip_address_allocation = "Dynamic"
    subnet_id = each.value.subnet_id
  }
}

# enable global peering between the two virtual network
resource "azurerm_virtual_network_peering" "peering" {
  for_each = local.vnet_department
  name                         = "peering-to-${each.key == "vnet_finance" ? "vnet_devops" : "vnet_finance"}"
  resource_group_name          = azurerm_resource_group.example.name
  virtual_network_name         = azurerm_virtual_network.vnet[each.key].name
  remote_virtual_network_id    = azurerm_virtual_network.vnet["${each.key == "vnet_finance" ? "vnet_devops" : "vnet_finance"}"].id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true

  # `allow_gateway_transit` must be set to false for vnet Global Peering
  allow_gateway_transit = false
}