# automation account
resource "azurerm_automation_account" "this" {
  resource_group_name = coalesce(var.account.resource_group_name, var.resource_group_name)
  location            = coalesce(var.account.location, var.location)

  name                          = var.account.name
  sku_name                      = var.account.sku_name
  local_authentication_enabled  = var.account.local_authentication_enabled
  public_network_access_enabled = var.account.public_network_access_enabled

  tags = coalesce(var.account.tags, var.tags)

  dynamic "identity" {
    for_each = var.account.identity != null ? { "this" = var.account.identity } : {}

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  dynamic "encryption" {
    for_each = var.account.encryption != null ? { "this" = var.account.encryption } : {}

    content {
      key_vault_key_id          = encryption.value.key_vault_key_id
      user_assigned_identity_id = encryption.value.user_assigned_identity_id
    }
  }
}


# modules
resource "azurerm_automation_module" "this" {
  for_each = {
    for module_name, module_info in var.account.modules : module_name => module_info
    if module_info.type != "powershell72"
  }

  resource_group_name = coalesce(var.account.resource_group_name, var.resource_group_name)

  name = coalesce(each.value.name, each.key)

  automation_account_name = azurerm_automation_account.this.name

  module_link {
    uri = each.value.uri

    # only shown when a module is linked via a URI
    dynamic "hash" {
      for_each = each.value.hash != null ? { "this" = each.value.hash } : {}

      content {
        algorithm = hash.value.algorithm
        value     = hash.value.value
      }
    }
  }
}

resource "azurerm_automation_powershell72_module" "this" {
  for_each = {
    for module_name, module_info in var.account.modules : module_name => module_info
    if module_info.type == "powershell72"
  }

  name = coalesce(each.value.name, each.key)

  automation_account_id = azurerm_automation_account.this.id

  tags = coalesce(var.account.tags, var.tags)

  module_link {
    uri = each.value.uri

    # only shown when a module is linked via a URI
    dynamic "hash" {
      for_each = each.value.hash != null ? { "this" = each.value.hash } : {}

      content {
        value     = hash.value.value
        algorithm = hash.value.algorithm
      }
    }
  }
}

# credentials
resource "azurerm_automation_credential" "this" {
  for_each = var.account.credentials

  resource_group_name = coalesce(var.account.resource_group_name, var.resource_group_name)

  name = coalesce(each.value.name, each.key)

  automation_account_name = azurerm_automation_account.this.name
  username                = each.value.username
  password                = each.value.password
  description             = each.value.description
}

# variable objects
resource "azurerm_automation_variable_string" "this" {
  for_each = {
    for key, value in var.account.variables : key => {
      value       = value.value
      encrypted   = try(value.encrypted, false)
      description = try(value.description, null)
      name        = coalesce(try(value.name, null), key)
    }

    if !can(tobool(value.value)) &&
    !can(tonumber(value.value)) &&
    !can(regex("^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(\\.\\d+)?(Z|[+-]\\d{2}:\\d{2})$", tostring(value.value))) &&
    !(can(jsonencode(value.value)) && !can(tostring(value.value)))
  }

  resource_group_name = coalesce(var.account.resource_group_name, var.resource_group_name)

  name = each.value.name

  automation_account_name = azurerm_automation_account.this.name
  value                   = tostring(each.value.value)
  encrypted               = each.value.encrypted
  description             = each.value.description
}

resource "azurerm_automation_variable_int" "this" {
  for_each = {
    for key, value in var.account.variables : key => {
      value       = value.value
      encrypted   = try(value.encrypted, false)
      description = try(value.description, null)
      name        = coalesce(try(value.name, null), key)
    }

    if can(tonumber(value.value)) && !can(tobool(value.value))
  }

  resource_group_name = coalesce(var.account.resource_group_name, var.resource_group_name)

  name                    = each.value.name
  automation_account_name = azurerm_automation_account.this.name
  value                   = tonumber(each.value.value)
  encrypted               = each.value.encrypted
  description             = each.value.description
}

resource "azurerm_automation_variable_bool" "this" {
  for_each = {
    for key, value in var.account.variables : key => {
      value       = value.value
      encrypted   = try(value.encrypted, false)
      description = try(value.description, null)
      name        = coalesce(try(value.name, null), key)
    }

    if can(tobool(value.value))
  }

  resource_group_name = coalesce(var.account.resource_group_name, var.resource_group_name)

  name                    = each.value.name
  automation_account_name = azurerm_automation_account.this.name
  value                   = tobool(each.value.value)
  encrypted               = each.value.encrypted
  description             = each.value.description
}

resource "azurerm_automation_variable_datetime" "this" {
  for_each = {
    for key, value in var.account.variables : key => {
      value       = value.value
      encrypted   = try(value.encrypted, false)
      description = try(value.description, null)
      name        = coalesce(try(value.name, null), key)
    }

    if can(regex("^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(\\.\\d+)?(Z|[+-]\\d{2}:\\d{2})$", tostring(value.value)))
  }

  resource_group_name = coalesce(var.account.resource_group_name, var.resource_group_name)

  name                    = each.value.name
  automation_account_name = azurerm_automation_account.this.name
  value                   = each.value.value
  encrypted               = each.value.encrypted
  description             = each.value.description
}

resource "azurerm_automation_variable_object" "this" {
  for_each = {
    for key, value in var.account.variables : key => {
      value       = value.value
      encrypted   = try(value.encrypted, false)
      description = try(value.description, null)
      name        = coalesce(try(value.name, null), key)
    }

    if can(jsonencode(value.value)) && !can(tostring(value.value))
  }

  resource_group_name = coalesce(var.account.resource_group_name, var.resource_group_name)

  name                    = each.value.name
  automation_account_name = azurerm_automation_account.this.name
  value                   = jsonencode(each.value.value)
  encrypted               = each.value.encrypted
  description             = each.value.description
}
