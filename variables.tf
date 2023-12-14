# secret
variable subscription_id {
  type        = string
}

variable rg_name {
  type        = string
  default = "NetworkWatcherRG"
}

variable rg_location {
  type        = string
  default = "West Europe"
}

variable nsg_name {
  type        = string
  default = "nsg-environment-automations"
}

variable security_rule_name {
  type        = string
  default = "test123"
}

variable security_rule_priority {
  type        = number
  default     = 1000
}

variable security_rule_direction {
  type        = string
  default     = "Outbound"
}

variable security_rule_access {
  type        = string
  default     = "Allow"
}

variable security_rule_protocol {
  type        = string
  default     = "*"
}

variable security_rule_source_port_range {
  type        = string
  default     = "*"
}

variable security_rule_destination_port_range {
  type        = string
  default     = "*"
}

variable security_rule_source_address_prefix {
  type        = string
  default     = "*"
}

variable security_rule_destination_address_prefix {
  type        = string
  default     = "*"
}


variable vnet_name {
  type        = string
  default = "vnet-environment-automations"
}

variable address_space {
  type        = list
  default = ["10.1.0.0/16"]
}

variable dns_servers {
  type        = list
  default = []
}

variable subnet_name {
  type        = string
  default = "snet-environment-automations"
}

variable subnet_address_prefix {
  type        = list
  default = ["10.1.1.0/24"]
}

variable vnet_storage_account_name {
  type        = string
  default =  "myfirsttrail"
}

variable app_service_plan_name{
  type = list(string)
  default =  ["app-subscriptions","app-storage-accounts","app-emails"]
}

variable function_app_name {
  type        = list(string)
  default =  ["func-subscriptions","func-storageaccounts","func-emails"]
}

variable function_app_settings {
  type        = list
}

variable logic_app_workflow_name {
  type        = list(string)
  default =["logic-app-storage-management","logic-app-subscription-management"]
}


variable key_vault_name {
  type        = string
  default = "kv-manageautomations1"
}

variable key_vault_sku_name {
  type        = string
  default     = "standard"
}

variable key_vault_certificate_permissions {
  type        = list
  default = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore"]
}

variable key_vault_key_permissions {
  type        = list
  default = ["Create","Get"]
}

variable key_vault_secret_permissions {
  type        = list
  default = ["Get","Set","Delete","Purge","Recover"]
}

variable key_vault_storage_permissions {
  type        = list
  default =  ["Get", ]
}

variable key_vault_secret_name {
  type        = string
  default     = "CONNECTION-STRING"
}




