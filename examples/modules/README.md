# Modules

This deploys one or more modules within the automation account

## Types

```hcl
account = object({
  name          = string
  resourcegroup = string
  location      = string
  modules = optional(map(object({
    uri  = string
    type = optional(string)
  })))
})
```

## Notes

If a module is marked as type powershell72, it uses the `azurerm_automation_powershell72_module` resource. If not, it defaults to the more generic `azurerm_automation_module`.
