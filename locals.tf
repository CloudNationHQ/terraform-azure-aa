locals {
  rfc3339_regex = "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(\\.\\d+)?(Z|[+-]\\d{2}:\\d{2})$"

  variables = flatten([
    for key, value in try(var.account.variables, {}) : {
      name  = try(value.name, join("-", [var.naming.automation_variable, key]))
      key   = key
      value = value.value
      type  = can(tobool(value.value)) ? "bool" : (
        can(tonumber(value.value)) ? "int" : (
          can(regex(local.rfc3339_regex, tostring(value.value))) ? "datetime" : (
            can(jsonencode(value.value)) && !can(tostring(value.value)) ? "object" : "string"
          )
        )
      )
    }
  ])
}
