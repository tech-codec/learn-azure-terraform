#create storage account
resource "azurerm_storage_account" "example" {
  name                     = "stleanr104"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = { environment = local.local_tags.environment }
}