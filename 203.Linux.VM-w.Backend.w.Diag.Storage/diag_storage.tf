resource "random_id" "randomid" {
  keepers = {
    resource_group = azurerm_resource_group.projectvm.name
  }
  byte_length = 8
}

resource "azurerm_storage_account" "projectvm" {
  name                        = "diag${random_id.randomid.hex}"
  resource_group_name         = azurerm_resource_group.projectvm.name
  location                    = azurerm_resource_group.projectvm.location
  account_replication_type    = "LRS"
  account_tier                = "Standard"

  tags = {
    environment = var.tag
  }
}

