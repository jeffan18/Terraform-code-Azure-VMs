resource "azurerm_resource_group" "fanvm" {
  name     = "RG-Fan-for-Github-Actions"
  location = "eastus"

  tags = {
    environment = "FanDev"
  }
}
