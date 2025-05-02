# automation account
resource "azurerm_automation_account" "aa" {
  name                          = var.config.name
  resource_group_name           = coalesce(lookup(var.config, "resource_group", null), var.resource_group)
  location                      = coalesce(lookup(var.config, "location", null), var.location)
  sku_name                      = try(var.config.sku_name, "Basic")
  local_authentication_enabled  = try(var.config.local_authentication_enabled, true)
  public_network_access_enabled = try(var.config.public_network_access_enabled, true)
  tags                          = try(var.config.tags, var.tags, null)

  dynamic "identity" {
    for_each = lookup(var.config, "identity", null) != null ? [var.config.identity] : []

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "encryption" {
    for_each = lookup(var.config, "encryption", null) != null ? [var.config.encryption] : []

    content {
      key_vault_key_id          = encryption.value.key_vault_key_id
      user_assigned_identity_id = try(encryption.value.user_assigned_identity_id, null)
    }
  }
}

# user managed identity
resource "azurerm_user_assigned_identity" "identity" {
  for_each = contains(["UserAssigned", "SystemAssigned, UserAssigned"], try(var.config.identity.type, "")) ? { "identity" = var.config.identity } : {}

  name                = try(each.value.name, "uai-${var.config.name}")
  resource_group_name = coalesce(lookup(var.config, "resource_group", null), var.resource_group)
  location            = coalesce(lookup(var.config, "location", null), var.location)
  tags                = try(var.config.tags, var.tags, null)
}

# modules
resource "azurerm_automation_module" "mod" {
  for_each = {
    for module_name, module_info in try(var.config.modules, {}) : module_name => module_info
    if !(lookup(module_info, "type", "") == "powershell72")
  }

  name                    = try(each.value.name, each.key)
  resource_group_name     = coalesce(lookup(var.config, "resource_group", null), var.resource_group)
  automation_account_name = azurerm_automation_account.aa.name

  module_link {
    uri = each.value.uri

    # only shown when a module is linked via a URI
    dynamic "hash" {
      for_each = lookup(each.value, "hash", null) != null ? [each.value.hash] : []

      content {
        algorithm = hash.value.algorithm
        value     = hash.value.value
      }
    }
  }
}

resource "azurerm_automation_powershell72_module" "modpwsh72" {
  for_each = {
    for module_name, module_info in try(var.config.modules, {}) : module_name => module_info
    if lookup(module_info, "type", "") == "powershell72"
  }

  name                  = try(each.value.name, each.key)
  automation_account_id = azurerm_automation_account.aa.id

  tags = try(
    var.config.tags, var.tags, null
  )

  module_link {
    uri = each.value.uri

    # only shown when a module is linked via a URI
    dynamic "hash" {
      for_each = lookup(each.value, "hash", null) != null ? [each.value.hash] : []

      content {
        value     = hash.value.value
        algorithm = hash.value.algorithm
      }
    }
  }
}

# credentials
resource "azurerm_automation_credential" "creds" {
  for_each = lookup(
    var.config, "credentials", {}
  )

  name                    = try(each.value.name, join("-", [var.naming.automation_credential, each.key]))
  resource_group_name     = coalesce(lookup(var.config, "resource_group", null), var.resource_group)
  automation_account_name = azurerm_automation_account.aa.name
  username                = each.value.username
  password                = each.value.password
  description             = try(each.value.description, null)
}

# variable objects
resource "azurerm_automation_variable_string" "variables" {
  for_each = {
    for key, value in try(var.config.variables, {}) : key => {
      name  = try(value.name, join("-", [var.naming.automation_variable, key]))
      value = value.value
    }

    if !can(tobool(value.value)) &&
    !can(tonumber(value.value)) &&
    !can(regex("^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(\\.\\d+)?(Z|[+-]\\d{2}:\\d{2})$", tostring(value.value))) &&
    !(can(jsonencode(value.value)) && !can(tostring(value.value)))
  }

  name                    = each.value.name
  resource_group_name     = coalesce(lookup(var.config, "resource_group", null), var.resource_group)
  automation_account_name = azurerm_automation_account.aa.name
  value                   = tostring(each.value.value)
  encrypted               = try(each.value.encrypted, false)
  description             = try(each.value.description, null)
}

resource "azurerm_automation_variable_int" "variables" {
  for_each = {
    for key, value in try(var.config.variables, {}) : key => {
      name  = try(value.name, join("-", [var.naming.automation_variable, key]))
      value = value.value
    }

    if can(tonumber(value.value)) && !can(tobool(value.value))
  }

  name                    = each.value.name
  resource_group_name     = coalesce(lookup(var.config, "resource_group", null), var.resource_group)
  automation_account_name = azurerm_automation_account.aa.name
  value                   = tonumber(each.value.value)
  encrypted               = try(each.value.encrypted, false)
  description             = try(each.value.description, null)
}

resource "azurerm_automation_variable_bool" "variables" {
  for_each = {
    for key, value in try(var.config.variables, {}) : key => {
      name  = try(value.name, join("-", [var.naming.automation_variable, key]))
      value = value.value
    }

    if can(tobool(value.value))
  }

  name                    = each.value.name
  resource_group_name     = coalesce(lookup(var.config, "resource_group", null), var.resource_group)
  automation_account_name = azurerm_automation_account.aa.name
  value                   = tobool(each.value.value)
  encrypted               = try(each.value.encrypted, false)
  description             = try(each.value.description, null)
}

resource "azurerm_automation_variable_datetime" "variables" {
  for_each = {
    for key, value in try(var.config.variables, {}) : key => {
      name  = try(value.name, join("-", [var.naming.automation_variable, key]))
      value = value.value
    }

    if can(regex("^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(\\.\\d+)?(Z|[+-]\\d{2}:\\d{2})$", tostring(value.value)))
  }

  name                    = each.value.name
  resource_group_name     = coalesce(lookup(var.config, "resource_group", null), var.resource_group)
  automation_account_name = azurerm_automation_account.aa.name
  value                   = each.value.value
  encrypted               = try(each.value.encrypted, false)
  description             = try(each.value.description, null)
}

resource "azurerm_automation_variable_object" "variables" {
  for_each = {
    for key, value in try(var.config.variables, {}) : key => {
      name  = try(value.name, join("-", [var.naming.automation_variable, key]))
      value = value.value
    }

    if can(jsonencode(value.value)) && !can(tostring(value.value))
  }

  name                    = each.value.name
  resource_group_name     = coalesce(lookup(var.config, "resource_group", null), var.resource_group)
  automation_account_name = azurerm_automation_account.aa.name
  value                   = jsonencode(each.value.value)
  encrypted               = try(each.value.encrypted, false)
  description             = try(each.value.description, null)
}
