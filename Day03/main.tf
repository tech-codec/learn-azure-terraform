terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=5.0.0"
    }
  }
}

provider "azurerm" {
  features {

  }
}


# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "rg-leanr-104"
  location = "canada central"
}

#create storage account
resource "azurerm_storage_account" "example" {
  name                     = "stleanr104"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = { environment = "Terraform Demo" }
}