
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "state_resource_group" {
  name     = var.rg_name
  location = "West Europe"
}




