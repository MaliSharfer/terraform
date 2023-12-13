variable subscription_id {
  type        = string
}


variable rg_name {
  type        = string
}

variable st_name {
  type        = string
  default     = "sttfstatemk3"
}

variable app_service_plan_name{
  type = list(string)
  default =  ["app-subscriptions1","app-storage-accounts1","app-emails1"]
}

variable function_app_name {
  type        = list(string)
  default =  ["func-subscriptions1","func-storageaccounts1","func-emails1"]
}

variable function_app_settings {
  type        = list
  default = [{
    "FUNCTIONS_WORKER_RUNTIME" = "python"
    "NUM_OF_MONTHS" = 1
    "COST" = 100
    "TABLE_SUBSCRIPTIONS_TO_DELETE" = "subscriptionsToDelete"
    "TABLE_DELETED_SUBSCRIPTIONS" = "deletedSubscriptions"
    "TABLE_SUBSCRIPTIONS_MANAGERS" = "subscriptionManagers"
    "TABLE_EMAILS" = "emails"
    "HTTP_TRIGGER_URL" = "https://function-send-email.azurewebsites.net/api/HttpTrigger1?code=_t5Z5vfMdHzcb2iHjbnv3sD-RQQ9V7uoqSJLFt6iXvBJAzFuMVp4hQ=="
    "RECIPIENT_EMAIL" = "YeuditC@skyvar.co.il"
    "SECRET" = "CONNECTION-STRING"
    "KEYVAULT_NAME" = "kv-chaya-try"
    "KEYVAULT_URI" = "https://kv-chaya-try.vault.azure.net"
    "SHELIS_EMAIL" = "ChayaH@skyvar.co.il"
    "TAG_NAME" = "essential"
  },{
    "FUNCTIONS_WORKER_RUNTIME" = "python"
    "DESIRED_TIME_PERIOD_SINCE_LAST_RETRIEVAL_FOR_CHECK_LAST_FETCH" = 30
    "DESIRED_TIME_PERIOD_SINCE_LAST_RETRIEVAL_FOR_CHECK_USED_CAPACITY" = 30
    "TIME_INDEX_FOR_CHECK_LAST_FETCH"="days"
    "TIME_INDEX_FOR_CHECK_USED_CAPACITY"="days"
    "FREQ_AUTOMATION_TEST_TYPE"="weeks"
    "FREQ_AUTOMATION_TEST_NUMBER"=1
    "ALERTS_DOCUMENTATION"="alertsDocumentation"
    "DOCUMENTATION_TABLE" ="documentation"
    "DELETED_ACCOUNTS_TABLE"="deletedStorages"
    "DOCUMENTATION_STORAGE_NAME"="myfirsttrail"
    "WORKSPACE_ID" = "fa9e707a-28c1-4528-b7b2-54d03360d4c9"
    "HTTP_TRIGGER_URL"="https://func-try-2.azurewebsites.net/api/HttpTrigger1?code=vqQyTSrot8Byr3-PUAWsHWWUBRImjzQp9DO_i8itYgKmAzFueI86Pg=="
    "MAIN_MANAGER"="batyag@skyvar.co.il"
    "ESSENTIAL_TAG"="essential"
  },{
    "FUNCTIONS_WORKER_RUNTIME" = "python"
    "EMAIL_SENDER" = "clouddg99@gmail.com"
    "SENDER_EMAIL_PASSWORD" = "sfipmkunckgmrshg"
    "SMTP_HOST" = "smtp.gmail.com"
    "SMTP_PORT" = 465
    "SECRET" = "CONNECTION-STRING"
    "KEYVAULT_NAME" = "kv-chaya-try"
    "KEYVAULT_URI" = "https://kv-chaya-try.vault.azure.net"
  }]
}




