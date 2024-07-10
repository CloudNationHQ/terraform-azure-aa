# Variable Objects

This deploys one or more variable objects within the automation account

## Types

```hcl
account = object({
  name          = string
  resourcegroup = string
  location      = string
  variables = optional(map(object({
    name  = optional(string)
    value = string
  })))
})
```
