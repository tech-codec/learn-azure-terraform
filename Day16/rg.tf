resource "azurerm_resource_group" "example" {
  name = "${var.resource_name_prefix}-rg"
  location = var.region
}