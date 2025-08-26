# Automation Account

This terraform module simplifies the process of creating and managing automation accounts on azure with customizable options and features, offering a flexible and powerful solution for managing azure automation through code.

## Features

Support for multiple variable objects

Ability to have multiple credentials for versatile access management

Utilization of terratest for robust validation

Capability to add multiple modules, including both generic and powershell modules

Ability to associate multiple runbooks with one or more schedules

Dynamic type inference for automation variables

Integrates seamlessly with private endpoint capabilities for direct and secure connectivity.

<!-- BEGIN_TF_DOCS -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 4.0)

## Resources

The following resources are used by this module:

- [azurerm_automation_account.aa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_account) (resource)
- [azurerm_automation_credential.creds](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_credential) (resource)
- [azurerm_automation_module.mod](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_module) (resource)
- [azurerm_automation_powershell72_module.modpwsh72](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_powershell72_module) (resource)
- [azurerm_automation_variable_bool.variables](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_variable_bool) (resource)
- [azurerm_automation_variable_datetime.variables](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_variable_datetime) (resource)
- [azurerm_automation_variable_int.variables](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_variable_int) (resource)
- [azurerm_automation_variable_object.variables](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_variable_object) (resource)
- [azurerm_automation_variable_string.variables](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_variable_string) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_config"></a> [config](#input\_config)

Description: automation account configuration

Type:

```hcl
object({
    name                          = string
    resource_group_name           = optional(string)
    location                      = optional(string)
    sku_name                      = optional(string, "Basic")
    local_authentication_enabled  = optional(bool, true)
    public_network_access_enabled = optional(bool, true)
    tags                          = optional(map(string))
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string), null)
    }), null)
    encryption = optional(object({
      key_vault_key_id          = string
      user_assigned_identity_id = optional(string, null)
    }), null)
    modules = optional(map(object({
      uri  = string
      name = optional(string, null)
      type = optional(string, null)
      hash = optional(object({
        algorithm = string
        value     = string
      }), null)
    })), {})
    credentials = optional(map(object({
      username    = string
      password    = string
      name        = optional(string, null)
      description = optional(string, null)
    })), {})
    variables = optional(any, {})
  })
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_location"></a> [location](#input\_location)

Description: default azure region to be used.

Type: `string`

Default: `null`

### <a name="input_naming"></a> [naming](#input\_naming)

Description: contains naming convention

Type: `map(string)`

Default: `{}`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: default resource group to be used.

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: tags to be added to the resources

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_config"></a> [config](#output\_config)

Description: contains automation account details
<!-- END_TF_DOCS -->

## Goals

For more information, please see our [goals and non-goals](./GOALS.md).

## Testing

For more information, please see our testing [guidelines](./TESTING.md)

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

To update the module's documentation run `make doc`

## Contributors

We welcome contributions from the community! Whether it's reporting a bug, suggesting a new feature, or submitting a pull request, your input is highly valued.

For more information, please see our contribution [guidelines](./CONTRIBUTING.md). <br><br>

<a href="https://github.com/cloudnationhq/terraform-azure-aa/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=cloudnationhq/terraform-azure-aa" />
</a>

## License

MIT Licensed. See [LICENSE](./LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/automation/)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/automation/)
