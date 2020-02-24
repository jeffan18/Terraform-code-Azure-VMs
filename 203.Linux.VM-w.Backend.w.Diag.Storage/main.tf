provider "azurerm" {
  subscription_id = ""
  tenant_id = ""
  client_id = ""
  client_secret = ""
}

terraform {
  backend "azurerm" {
    resource_group_name   = "RG-Common-Resources" 
    storage_account_name  = "forterraformbackend"
    container_name        = "tfstate"
    access_key = "qXRMCmbVZuqd5OJm6Wk39MuYvlhnHdmgDABoQXppavuAzp2nzbvEc9I0dbrsQ2xiZH/njX/rjv30jrA7jCvgJQ=="
    key = "project-VM-Linux-20200220.txt"
  }
}

data "azurerm_subscription" "current" {}
