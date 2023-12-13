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


resource "azurerm_app_service_plan" "example" {
  name                = "app-service-plan-newnew21"
  location            = "East US"
  resource_group_name = data.azurerm_storage_account.vnet_storage_account.resource_group_name
  kind                = "Linux"
  reserved            = true
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "example" {
  name                      = "mali-function-newnew11"
  location                  = data.azurerm_storage_account.vnet_storage_account.location
  resource_group_name       = data.azurerm_storage_account.vnet_storage_account.resource_group_name
  app_service_plan_id       = azurerm_app_service_plan.example.id
  storage_account_name      = data.azurerm_storage_account.vnet_storage_account.name
  storage_account_access_key = data.azurerm_storage_account.vnet_storage_account.primary_access_key
  os_type                   = "linux"
  version                   = "~4"

  app_settings = {
  "FUNCTIONS_WORKER_RUNTIME" = "python"
  "AzureWebJobsStorage"      = data.azurerm_storage_account.vnet_storage_account.primary_connection_string
  
  }

  site_config {
    linux_fx_version = "python|3.11"
  }

  identity {
    type = "SystemAssigned"
  }

}


















# resource "azurerm_linux_function_app" "linux_function_app" {
#   name                = "func-subscriptions1"
#   resource_group_name = data.azurerm_storage_account.vnet_storage_account.resource_group_name
#   location            = data.azurerm_storage_account.vnet_storage_account.location

#   storage_account_name       = data.azurerm_storage_account.vnet_storage_account.name
#   storage_account_access_key = data.azurerm_storage_account.vnet_storage_account.primary_access_key
#   service_plan_id            = azurerm_service_plan.service_plan.id

#   app_settings = {
#     "FUNCTIONS_WORKER_RUNTIME" = "python"
#     "NUM_OF_MONTHS" = 1
#     "COST" = 100
#     "TABLE_SUBSCRIPTIONS_TO_DELETE" = "subscriptionsToDelete"
#     "TABLE_DELETED_SUBSCRIPTIONS" = "deletedSubscriptions"
#     "TABLE_SUBSCRIPTIONS_MANAGERS" = "subscriptionManagers"
#     "TABLE_EMAILS" = "emails"
#     "HTTP_TRIGGER_URL" = "https://function-send-email.azurewebsites.net/api/HttpTrigger1?code=_t5Z5vfMdHzcb2iHjbnv3sD-RQQ9V7uoqSJLFt6iXvBJAzFuMVp4hQ=="
#     "RECIPIENT_EMAIL" = "YeuditC@skyvar.co.il"
#     "SECRET" = "CONNECTION-STRING"
#     "KEYVAULT_NAME" = "kv-chaya-try"
#     "KEYVAULT_URI" = "https://kv-chaya-try.vault.azure.net"
#     "SHELIS_EMAIL" = "ChayaH@skyvar.co.il"
#     "TAG_NAME" = "essential"
#   }
#   site_config {}

#   identity {
#     type = "SystemAssigned"
#   }

#   # count = length(azurerm_service_plan.service_plan)

# }