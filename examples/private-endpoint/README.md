# Private Endpoint

This deploys private endpoint for automation accounts

## Types

```hcl
config = object({
  name           = string
  location       = string
  resource_group = string

  public_network_access_enabled = optional(bool)
})
```

## Notes

Additional modules will be used to configure private endpoints and private dns zones.

Currently, there’s no dedicated subresource or private endpoint support solely for cloud-based runbooks. Therefore it's tied to the subresource DSCAndHybridWorker.
