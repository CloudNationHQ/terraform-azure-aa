# Credentials

This deploys one or more credentials within the automation account

## Types

```hcl
config = object({
  name          = string
  resourcegroup = string
  location      = string
  credentials = optional(map(object({
    username = string
    password = string
  })))
})
```
