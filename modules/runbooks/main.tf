resource "azurerm_automation_runbook" "runbooks" {
  for_each = var.runbooks

  name                    = try(each.value.name, join("-", [var.naming.automation_runbook, each.key]))
  resource_group_name     = coalesce(lookup(var.runbooks, "resourcegroup", null), var.resourcegroup)
  location                = coalesce(lookup(var.runbooks, "location", null), var.location)
  automation_account_name = coalesce(lookup(var.runbooks, "automation_account", null), var.automation_account)
  log_verbose             = each.value.log_verbose
  log_progress            = each.value.log_progress
  description             = try(each.value.description, null)
  runbook_type            = each.value.runbook_type
  content                 = try(each.value.content, null)
  tags                    = try(var.runbooks.tags, var.tags, null)

  dynamic "publish_content_link" {
    for_each = contains(keys(each.value), "publish_content_link") ? [each.value.publish_content_link] : []
    content {
      uri = publish_content_link.value.uri
    }
  }

  dynamic "draft" {
    for_each = contains(keys(each.value), "draft") ? [each.value.draft] : []
    content {
      edit_mode_enabled = try(draft.value.edit_mode_enabled, null)
      output_types      = try(draft.value.output_types, null)

      dynamic "content_link" {
        for_each = contains(keys(draft.value), "content_link") ? [draft.value.content_link] : []
        content {
          uri = content_link.value.uri
        }
      }
    }
  }
}

# schedules
resource "azurerm_automation_schedule" "schedules" {
  for_each = local.flattened_schedules

  name                    = try(each.value.name, join("-", [var.naming.automation_schedule, each.key]))
  resource_group_name     = var.resourcegroup
  automation_account_name = var.automation_account
  frequency               = each.value.frequency
  interval                = each.value.interval
  timezone                = each.value.timezone
  start_time              = each.value.start_time
  description             = try(each.value.description, null)
  week_days               = try(each.value.week_days, null)
  month_days              = try(each.value.month_days, null)
}

# Job Schedules
resource "azurerm_automation_job_schedule" "job_schedules" {
  for_each = local.flattened_schedules

  resource_group_name     = var.resourcegroup
  automation_account_name = var.automation_account
  schedule_name           = azurerm_automation_schedule.schedules[each.key].name
  runbook_name            = azurerm_automation_runbook.runbooks[each.value.runbook_key].name
  parameters              = try(each.value.job_schedule_parameters, null)
}
