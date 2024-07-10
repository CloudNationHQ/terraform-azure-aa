# Complete

This example highlights the complete usage.

## Types

```hcl
account = object({
  name          = optional(string)
  resourcegroup = optional(string)
  location      = string
  variables = optional(map(object({
    value = string # This should be a jsonencoded string
  })))
  modules = optional(map(object({
    uri  = string
    type = optional(string)
  })))
  credentials = optional(map(object({
    username = string
    password = string
  })))
})
```
