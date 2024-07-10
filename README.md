# Automation Account

This terraform module simplifies the process of creating and managing automation accounts on azure with customizable options and features, offering a flexible and powerful solution for managing azure automation through code.

## Goals

The main objective is to create a more logic data structure, achieved by combining and grouping related resources together in a complex object.

The structure of the module promotes reusability. It's intended to be a repeatable component, simplifying the process of building diverse workloads and platform accelerators consistently.

A primary goal is to utilize keys and values in the object that correspond to the REST API's structure. This enables us to carry out iterations, increasing its practical value as time goes on.

A last key goal is to separate logic from configuration in the module, thereby enhancing its scalability, ease of customization, and manageability.

## Features

- support for multiple variable objects
- ability to have multiple credentials for versatile access management
- utilization of terratest for robust validation
- capability to add multiple modules, including both generic and powershell modules
- ability to associate multiple runbooks with one or more schedules

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.61 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.61 |

## Modules

| Name | Source |
|------|--------|
| [runbooks](./modules/runbooks) | resource |

## Resources

| Name | Type |
|------|------|
| [azurerm_automation_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_account) | resource |
| [azurerm_automation_credential](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_credential) | resource |
| [azurerm_automation_module](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_module) | resource |
| [azurerm_automation_powershell72_module](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_powershell72_module) | resource |
| [azurerm_automation_variable_object](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_variable_object) | resource |
| [azurerm_user_assigned_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_automation_job_schedule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_job_schedule) | resource |
| [azurerm_automation_runbook](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_runbook) | resource |
| [azurerm_automation_schedule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_schedule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `account` | contains automation account details | any | n/a | yes |
| `naming` | contains naming convention | string | yes |
| `location` | default azure region to be used | string | no |
| `resourcegroup` | default resource group to be used | string | no |
| `tags` | tags to be added to the resources | map(string) | no |

## Outputs

| Name | Description |
| :-- | :-- |
| `account` | automation account details |

## Testing

As a prerequirement, please ensure that both go and terraform are properly installed on your system.

The [Makefile](Makefile) includes two distinct variations of tests. The first one is designed to deploy different usage scenarios of the module. These tests are executed by specifying the TF_PATH environment variable, which determines the different usages located in the example directory.

To execute this test, input the command ```make test TF_PATH=default```, substituting default with the specific usage you wish to test.

The second variation is known as a extended test. This one performs additional checks and can be executed without specifying any parameters, using the command ```make test_extended```.

Both are designed to be executed locally and are also integrated into the github workflow.

Each of these tests contributes to the robustness and resilience of the module. They ensure the module performs consistently and accurately under different scenarios and configurations.

## Notes

Using a dedicated module, we've developed a naming convention for resources that's based on specific regular expressions for each type, ensuring correct abbreviations and offering flexibility with multiple prefixes and suffixes.

Full examples detailing all usages, along with integrations with dependency modules, are located in the examples directory.

## Authors

Module is maintained by [these awesome contributors](https://github.com/cloudnationhq/terraform-azure-aa/graphs/contributors).

## License

MIT Licensed. See [LICENSE](https://github.com/cloudnationhq/terraform-azure-aa/blob/main/LICENSE) for full details.

## References

- [Documentation](https://learn.microsoft.com/en-us/azure/automation/)
- [Rest Api](https://learn.microsoft.com/en-us/rest/api/automation/)
