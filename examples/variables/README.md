# Variables

This deploys one or more variables within the automation account

## Types

```hcl
config = object({
  name          = string
  resourcegroup = string
  location      = string
  variables = optional(map(object({
    name  = optional(string)
    value = any
  })))
})
```

## Notes

The any type allows for values of any data type, enabling dynamic type determination at runtime.

Different Azure Automation variable resources are dynamically created based on the inferred types.
