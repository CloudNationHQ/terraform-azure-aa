# automation account
resource "azurerm_automation_account" "aa" {
  name                          = var.account.name
  resource_group_name           = coalesce(lookup(var.account, "resourcegroup", null), var.resourcegroup)
  location                      = coalesce(lookup(var.account, "location", null), var.location)
  sku_name                      = try(var.account.sku_name, "Basic")
  local_authentication_enabled  = try(var.account.local_authentication_enabled, true)
  public_network_access_enabled = try(var.account.public_network_access_enabled, true)
  tags                          = try(var.account.tags, var.tags, null)

  dynamic "identity" {
    for_each = [lookup(var.account, "identity", { type = "SystemAssigned", identity_ids = [] })]

    content {
      type = identity.value.type
      identity_ids = concat(
        try([azurerm_user_assigned_identity.identity["identity"].id], []),
        lookup(identity.value, "identity_ids", [])
      )
    }
  }
}

# user managed identity
resource "azurerm_user_assigned_identity" "identity" {
  for_each = contains(["UserAssigned", "SystemAssigned, UserAssigned"], try(var.account.identity.type, "")) ? { "identity" = var.account.identity } : {}

  name                = try(each.value.name, "uai-${var.account.name}")
  resource_group_name = coalesce(lookup(var.account, "resourcegroup", null), var.resourcegroup)
  location            = coalesce(lookup(var.account, "location", null), var.location)
  tags                = try(var.account.tags, var.tags, null)
}

# modules
resource "azurerm_automation_module" "mod" {
  for_each = {
    for module_name, module_info in try(var.account.modules, {}) :
    module_name => module_info
    if !(lookup(module_info, "type", "") == "powershell72")
  }

  name                    = try(each.value.name, each.key)
  resource_group_name     = coalesce(lookup(var.account, "resourcegroup", null), var.resourcegroup)
  automation_account_name = azurerm_automation_account.aa.name

  module_link {
    uri = each.value.uri
  }
}

resource "azurerm_automation_powershell72_module" "modpwsh72" {
  for_each = {
    for module_name, module_info in try(var.account.modules, {}) :
    module_name => module_info
    if lookup(module_info, "type", "") == "powershell72"
  }

  name                  = try(each.value.name, each.key)
  automation_account_id = azurerm_automation_account.aa.id

  module_link {
    uri = each.value.uri
  }
}

# credentials
resource "azurerm_automation_credential" "creds" {
  for_each = lookup(
    var.account, "credentials", {}
  )

  name                    = try(each.value.name, join("-", [var.naming.automation_credential, each.key]))
  resource_group_name     = coalesce(lookup(var.account, "resourcegroup", null), var.resourcegroup)
  automation_account_name = azurerm_automation_account.aa.name
  username                = each.value.username
  password                = each.value.password
  description             = try(each.value.description, null)
}

# variable objects
resource "azurerm_automation_variable_string" "variables" {
  for_each = {
    for v in local.variables : v.key => v
    if v.type == "string"
  }

  name                    = each.value.name
  resource_group_name     = coalesce(lookup(var.account, "resourcegroup", null), var.resourcegroup)
  automation_account_name = azurerm_automation_account.aa.name
  value                   = tostring(each.value.value)
}

resource "azurerm_automation_variable_int" "variables" {
  for_each = {
    for v in local.variables : v.key => v
    if v.type == "int"
  }

  name                    = each.value.name
  resource_group_name     = coalesce(lookup(var.account, "resourcegroup", null), var.resourcegroup)
  automation_account_name = azurerm_automation_account.aa.name
  value                   = tonumber(each.value.value)
}

resource "azurerm_automation_variable_bool" "variables" {
  for_each = {
    for v in local.variables : v.key => v
    if v.type == "bool"
  }

  name                    = each.value.name
  resource_group_name     = coalesce(lookup(var.account, "resourcegroup", null), var.resourcegroup)
  automation_account_name = azurerm_automation_account.aa.name
  value                   = tobool(each.value.value)
}

resource "azurerm_automation_variable_datetime" "variables" {
  for_each = {
    for v in local.variables : v.key => v
    if v.type == "datetime"
  }

  name                    = each.value.name
  resource_group_name     = coalesce(lookup(var.account, "resourcegroup", null), var.resourcegroup)
  automation_account_name = azurerm_automation_account.aa.name
  value                   = each.value.value
}

resource "azurerm_automation_variable_object" "variables" {
  for_each = {
    for v in local.variables : v.key => v
    if v.type == "object"
  }

  name                    = each.value.name
  resource_group_name     = coalesce(lookup(var.account, "resourcegroup", null), var.resourcegroup)
  automation_account_name = azurerm_automation_account.aa.name
  value                   = jsonencode(each.value.value)
}
