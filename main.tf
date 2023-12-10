terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "NetworkWatcherRG"
    storage_account_name = "myfirsttrail"
    container_name       = "terraformstatedemo"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  subscription_id = "4b790616-7e75-4a6a-a4e0-52db256f6ad9"
}

resource "azurerm_resource_group" "state_resource_group" {
  name     = var.rg_name
  location = "West Europe"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.st_name
  resource_group_name      = azurerm_resource_group.state_resource_group.name
  location                 = azurerm_resource_group.state_resource_group.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "staging"
  }
}