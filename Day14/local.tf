locals {
  Common_tags = {
    finance = "finance"
    production = "production"
  }
  nsg_rules = {
    "Allow-LB-Probe-To-VMSS" = {
      priority                   = 100
      access                     = "Allow"
      destination_port_range     = "80"
      source_address_prefix      = "AzureLoadBalancer"
    }

    "Allow-HTTP-To-VMSS" = {
      priority                   = 110
      access                     = "Allow"
      destination_port_range     = "80"
      source_address_prefix      = "Internet"
    }

    "Allow-ssh-To-VMSS" = {
      priority                   = 120
      access                     = "Allow"
      destination_port_range     = "22"
      source_address_prefix      = "Internet"
    }

    "deny-all-inbound-traffic" = {
      priority                   = 130
      access                     = "Deny"
      destination_port_range     = "*"
      source_address_prefix      = "*"
    }
  }

  nsg_subnets = {
    subnet1 = azurerm_subnet.subnet1.id
    subnet2 = azurerm_subnet.subnet2.id
  }
  
}