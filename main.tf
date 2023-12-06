provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = "a173eef2-33d7-4d55-b0b5-18b271f8d42b"
}

resource "azurerm_resource_group" "vnet_resource_group" {
  name     = "rg-cicd-for-terraform"
  location = "West Europe"
} 