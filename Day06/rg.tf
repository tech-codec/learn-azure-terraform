# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "rg-leanr-104"
  location = "canada central"
}