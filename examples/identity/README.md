# Default

This example illustrates the default setup, in its simplest form.

## Types

```hcl
config = object({
  name           = string
  resource_group = string
  location       = string

  identity = optional(object({
    type         = string
    identity_ids = list(string)
  }))
})
```

