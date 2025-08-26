# automation account
resource "azurerm_automation_account" "aa" {
  resource_group_name = coalesce(
    lookup(
      var.config, "resource_group_name", null
    ), var.resource_group_name
  )

  location = coalesce(
    lookup(
      var.config, "location", null
    ), var.location
  )

  name                          = var.config.name
  sku_name                      = var.config.sku_name
  local_authentication_enabled  = var.config.local_authentication_enabled
  public_network_access_enabled = var.config.public_network_access_enabled

  tags = coalesce(
    var.config.tags, var.tags
  )

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
      user_assigned_identity_id = encryption.value.user_assigned_identity_id
    }
  }
}

# modules
resource "azurerm_automation_module" "mod" {
  for_each = {
    for module_name, module_info in var.config.modules : module_name => module_info
    if !(lookup(module_info, "type", "") == "powershell72")
  }

  resource_group_name = coalesce(
    lookup(
      var.config, "resource_group_name", null
    ), var.resource_group_name
  )

  name = coalesce(
    each.value.name, each.key
  )

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
    for module_name, module_info in var.config.modules : module_name => module_info
    if lookup(module_info, "type", "") == "powershell72"
  }

  name = coalesce(
    each.value.name, each.key
  )

  automation_account_id = azurerm_automation_account.aa.id

  tags = coalesce(
    var.config.tags, var.tags
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
  for_each = var.config.credentials

  resource_group_name = coalesce(
    lookup(
      var.config, "resource_group_name", null
    ), var.resource_group_name
  )

  name = coalesce(
    each.value.name, try(
      join("-", [var.naming.automation_credential, each.key]), null
    ), each.key
  )

  automation_account_name = azurerm_automation_account.aa.name
  username                = each.value.username
  password                = each.value.password
  description             = each.value.description
}

# variable objects
resource "azurerm_automation_variable_string" "variables" {
  for_each = {
    for key, value in var.config.variables : key => {
      value       = value.value
      encrypted   = try(value.encrypted, false)
      description = try(value.description, null)
      name = coalesce(
        try(value.name, null), try(
          join("-", [var.naming.automation_variable, key]), null
        ), key
      )
    }

    if !can(tobool(value.value)) &&
    !can(tonumber(value.value)) &&
    !can(regex("^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(\\.\\d+)?(Z|[+-]\\d{2}:\\d{2})$", tostring(value.value))) &&
    !(can(jsonencode(value.value)) && !can(tostring(value.value)))
  }

  resource_group_name = coalesce(
    lookup(
      var.config, "resource_group_name", null
    ), var.resource_group_name
  )

  name = each.value.name

  automation_account_name = azurerm_automation_account.aa.name
  value                   = tostring(each.value.value)
  encrypted               = each.value.encrypted
  description             = each.value.description
}

resource "azurerm_automation_variable_int" "variables" {
  for_each = {
    for key, value in var.config.variables : key => {
      value       = value.value
      encrypted   = try(value.encrypted, false)
      description = try(value.description, null)
      name = coalesce(
        try(value.name, null), try(
          join("-", [var.naming.automation_variable, key]), null
        ), key
      )
    }

    if can(tonumber(value.value)) && !can(tobool(value.value))
  }

  resource_group_name = coalesce(
    lookup(
      var.config, "resource_group_name", null
    ), var.resource_group_name
  )

  name                    = each.value.name
  automation_account_name = azurerm_automation_account.aa.name
  value                   = tonumber(each.value.value)
  encrypted               = each.value.encrypted
  description             = each.value.description
}

resource "azurerm_automation_variable_bool" "variables" {
  for_each = {
    for key, value in var.config.variables : key => {
      value       = value.value
      encrypted   = try(value.encrypted, false)
      description = try(value.description, null)
      name = coalesce(
        try(value.name, null), try(
          join("-", [var.naming.automation_variable, key]), null
        ), key
      )
    }

    if can(tobool(value.value))
  }

  resource_group_name = coalesce(
    lookup(
      var.config, "resource_group_name", null
    ), var.resource_group_name
  )

  name                    = each.value.name
  automation_account_name = azurerm_automation_account.aa.name
  value                   = tobool(each.value.value)
  encrypted               = each.value.encrypted
  description             = each.value.description
}

resource "azurerm_automation_variable_datetime" "variables" {
  for_each = {
    for key, value in var.config.variables : key => {
      value       = value.value
      encrypted   = try(value.encrypted, false)
      description = try(value.description, null)
      name = coalesce(
        try(value.name, null), try(
          join("-", [var.naming.automation_variable, key]), null
        ), key
      )
    }

    if can(regex("^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(\\.\\d+)?(Z|[+-]\\d{2}:\\d{2})$", tostring(value.value)))
  }

  resource_group_name = coalesce(
    lookup(
      var.config, "resource_group_name", null
    ), var.resource_group_name
  )

  name                    = each.value.name
  automation_account_name = azurerm_automation_account.aa.name
  value                   = each.value.value
  encrypted               = each.value.encrypted
  description             = each.value.description
}

resource "azurerm_automation_variable_object" "variables" {
  for_each = {
    for key, value in var.config.variables : key => {
      value       = value.value
      encrypted   = try(value.encrypted, false)
      description = try(value.description, null)
      name = coalesce(
        try(value.name, null), try(
          join("-", [var.naming.automation_variable, key]), null
        ), key
      )
    }

    if can(jsonencode(value.value)) && !can(tostring(value.value))
  }

  resource_group_name = coalesce(
    lookup(
      var.config, "resource_group_name", null
    ), var.resource_group_name
  )

  name                    = each.value.name
  automation_account_name = azurerm_automation_account.aa.name
  value                   = jsonencode(each.value.value)
  encrypted               = each.value.encrypted
  description             = each.value.description
}
