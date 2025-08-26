# Runbooks

This submodule focuses on managing runbooks and their associated schedules.

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

- [azurerm_automation_job_schedule.job_schedules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_job_schedule) (resource)
- [azurerm_automation_runbook.runbooks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_runbook) (resource)
- [azurerm_automation_schedule.schedules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_schedule) (resource)
- [azurerm_automation_webhook.webhooks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_webhook) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_config"></a> [config](#input\_config)

Description: contains the runbooks configuration

Type:

```hcl
map(object({
    name                     = optional(string)
    description              = optional(string)
    content                  = optional(string)
    log_activity_trace_level = optional(number)
    runbook_type             = string
    log_verbose              = bool
    log_progress             = bool
    publish_content_link = optional(object({
      uri     = string
      version = optional(string)
      hash = optional(object({
        algorithm = string
        value     = string
      }))
    }))
    draft = optional(object({
      content           = optional(string)
      edit_mode_enabled = optional(bool)
      output_types      = optional(list(string))
      parameters = optional(map(object({
        type          = string
        mandatory     = optional(bool)
        position      = optional(number)
        default_value = optional(string)
      })))
      content_link = optional(object({
        uri     = string
        version = optional(string)
        hash = optional(object({
          algorithm = string
          value     = string
        }))
      }))
    }))
    schedules = optional(map(object({
      frequency   = string
      interval    = number
      timezone    = string
      start_time  = string
      name        = optional(string)
      description = optional(string)
      week_days   = optional(list(string))
      month_days  = optional(list(number))
      expiry_time = optional(string)
      monthly_occurrence = optional(object({
        day = string
      }))
      job_schedule_parameters = optional(map(string))
      run_on                  = optional(string)
    })))
    webhooks = optional(map(object({
      expiry_time         = string
      name                = optional(string)
      enabled             = optional(bool, true)
      run_on_worker_group = optional(string)
      parameters          = optional(map(string))
      uri                 = optional(string)
    })))
  }))
```

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_automation_account"></a> [automation\_account](#input\_automation\_account)

Description: contains the automation account name

Type: `string`

Default: `null`

### <a name="input_location"></a> [location](#input\_location)

Description: contains the region

Type: `string`

Default: `null`

### <a name="input_naming"></a> [naming](#input\_naming)

Description: used for naming purposes

Type: `map(string)`

Default: `{}`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: contains the resourcegroup name

Type: `string`

Default: `null`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: tags to be added to the resources

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_runbook"></a> [runbook](#output\_runbook)

Description: contains runbook details

### <a name="output_webhook"></a> [webhook](#output\_webhook)

Description: contains webhook details
<!-- END_TF_DOCS -->
