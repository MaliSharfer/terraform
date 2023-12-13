terraform {
  backend "azurerm" {
    resource_group_name      = "NetworkWatcherRG"
    storage_account_name     = "myfirsttrail"
    container_name           = "terraformstate"
    key                      = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  subscription_id = var.subscription_id
}

data "azurerm_resource_group" "vnet_resource_group" {
  name     = var.rg_name
}

data "azurerm_storage_account" "vnet_storage_account"{
  name ="myfirsttrail"
  resource_group_name = data.azurerm_resource_group.vnet_resource_group.name
}


resource "azurerm_service_plan" "service_plan" {
  name                = each.value
  resource_group_name = data.azurerm_resource_group.vnet_resource_group.name
  location            = data.azurerm_resource_group.vnet_resource_group.location
  os_type             = "Linux"
  sku_name            = "P1v2"
  for_each = toset(var.app_service_plan_name)
}

resource "azurerm_linux_function_app" "linux_function_app" {
  name                = var.function_app_name[count.index]
  resource_group_name = data.azurerm_storage_account.vnet_storage_account.resource_group_name
  location            = data.azurerm_storage_account.vnet_storage_account.location

  storage_account_name       = data.azurerm_storage_account.vnet_storage_account.name
  storage_account_access_key = data.azurerm_storage_account.vnet_storage_account.primary_access_key
  service_plan_id            = azurerm_service_plan.service_plan[var.app_service_plan_name[count.index]].id

  app_settings = {for key, value in var.function_app_settings[count.index]: key =>value}
  site_config {}

  identity {
    type = "SystemAssigned"
  }

  count = length(azurerm_service_plan.service_plan)

}