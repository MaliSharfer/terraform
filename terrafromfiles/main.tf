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
  location            = data.azurerm_storage_account.vnet_storage_account.location
  resource_group_name = data.azurerm_storage_account.vnet_storage_account.resource_group_name
  kind                = "FunctionApp"
  reserved            = true
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
  for_each = toset(var.app_service_plan_name)
}


resource "azurerm_function_app" "function_app" {
  name                      = var.function_app_name[count.index]
  location                  = data.azurerm_storage_account.vnet_storage_account.location
  resource_group_name       = data.azurerm_storage_account.vnet_storage_account.resource_group_name
  app_service_plan_id       = azurerm_app_service_plan.app_service_plan[var.app_service_plan_name[count.index]].id
  storage_account_name      = data.azurerm_storage_account.vnet_storage_account.name
  storage_account_access_key =data.azurerm_storage_account.vnet_storage_account.primary_access_key
  os_type                   = "linux"
  version                   = "~4"

  app_settings = {for key, value in var.function_app_settings[count.index]: key =>value}
  site_config {
    linux_fx_version = "python|3.11"
  }

  identity {
    type = "SystemAssigned"
  }
  
  count = length(var.app_service_plan_name)
}

resource "azurerm_logic_app_workflow" "logic_app_workflow" {
  name                = each.value
  location            = data.azurerm_resource_group.vnet_resource_group.location
  resource_group_name = data.azurerm_resource_group.vnet_resource_group.name
  for_each            = toset(var.logic_app_workflow_name)
}

data "azurerm_client_config" "current_client" {}

resource "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  location            = "West Europe"
  resource_group_name = data.azurerm_storage_account.vnet_storage_account.resource_group_name
  soft_delete_retention_days  = 7
  tenant_id           = data.azurerm_client_config.current_client.tenant_id
  sku_name            = var.key_vault_sku_name

  access_policy {
    tenant_id = data.azurerm_client_config.current_client.tenant_id
    object_id = data.azurerm_client_config.current_client.object_id

    certificate_permissions = var.key_vault_certificate_permissions

    key_permissions = var.key_vault_key_permissions

    secret_permissions = var.key_vault_secret_permissions

    storage_permissions = var.key_vault_storage_permissions
  }
}

resource "azurerm_key_vault_secret" "key_vault_secret" {
  name         = var.key_vault_secret_name
  value        = data.azurerm_storage_account.vnet_storage_account.primary_connection_string
  key_vault_id = azurerm_key_vault.key_vault.id
}

