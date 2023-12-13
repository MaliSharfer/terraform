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
  name =var.vnet_storage_account_name
  resource_group_name = data.azurerm_resource_group.vnet_resource_group.name
}

# resource "azurerm_network_security_group" "network_security_group" {
#   name                = var.nsg_name
#   location            = data.azurerm_resource_group.vnet_resource_group.location
#   resource_group_name = data.azurerm_resource_group.vnet_resource_group.name

#   security_rule {
#     name                       = var.security_rule_name
#     priority                   = var.security_rule_priority
#     direction                  = var.security_rule_direction
#     access                     = var.security_rule_access
#     protocol                   = var.security_rule_protocol
#     source_port_range          = var.security_rule_source_port_range
#     destination_port_range     = var.security_rule_destination_port_range
#     source_address_prefix      = var.security_rule_source_address_prefix
#     destination_address_prefix = var.security_rule_destination_address_prefix
#   }
# }



resource "azurerm_virtual_network" "virtual_network" {
  name                = var.vnet_name
  location            = data.azurerm_resource_group.vnet_resource_group.location
  resource_group_name = data.azurerm_resource_group.vnet_resource_group.name
  address_space       = var.address_space
  dns_servers         = var.dns_servers
}

resource "azurerm_subnet" "vnet_subnet" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.vnet_resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = var.subnet_address_prefix
}



resource "azurerm_app_service_plan" "app_service_plan" {
  name                = each.value
  location            = data.azurerm_resource_group.vnet_resource_group.location
  resource_group_name = data.azurerm_resource_group.vnet_resource_group.name
  kind                = "Linux"
  reserved            = true
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
  for_each = toset(var.app_service_plan_name)
}

resource "azurerm_function_app" "function_app" {
  name                      = var.function_app_name[count.index+1]
  location                  = data.azurerm_storage_account.vnet_storage_account.location
  resource_group_name       = data.azurerm_storage_account.vnet_storage_account.resource_group_name
  app_service_plan_id       = azurerm_app_service_plan.app_service_plan[var.app_service_plan_name[count.index+1]].id
  storage_account_name      = data.azurerm_storage_account.vnet_storage_account.name
  storage_account_access_key =data.azurerm_storage_account.vnet_storage_account.primary_access_key
  os_type                   = "linux"
  version                   = "~4"

  app_settings = {for key, value in var.function_app_settings[count.index+1]: key =>value}
  site_config {
    linux_fx_version = "python|3.11"
  }

  identity {
    type = "SystemAssigned"
  }
  
  count = length(azurerm_app_service_plan.app_service_plan)
}

resource "azurerm_logic_app_workflow" "logic_app_workflow" {
  name                = each.value
  location            = data.azurerm_resource_group.vnet_resource_group.location
  resource_group_name = data.azurerm_resource_group.vnet_resource_group.name
  for_each            = toset(var.logic_app_workflow_name)
}

data "azurerm_client_config" "current_client" {}

data "azurerm_key_vault" "key_vault" {
  name = "kv-chaya-try"
  resource_group_name = "rg-chaya-subscription-management"
}


data "azurerm_subscription" "primary" {
}

resource "azurerm_role_assignment" "example" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Reader"
  principal_id         = azurerm_function_app.function_app[0].identity[0].principal_id 
}

resource "azurerm_role_assignment" "key_vault_access" {
  scope                = data.azurerm_key_vault.key_vault.id 
  role_definition_name = "Key Vault Administrator"  
  principal_id         = azurerm_function_app.function_app[0].identity[0].principal_id
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