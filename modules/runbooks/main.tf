resource "azurerm_automation_runbook" "runbooks" {
  for_each = var.config

  name                     = try(each.value.name, join("-", [var.naming.automation_runbook, each.key]))
  resource_group_name      = coalesce(lookup(var.config, "resource_group", null), var.resource_group)
  location                 = coalesce(lookup(var.config, "location", null), var.location)
  automation_account_name  = coalesce(lookup(var.config, "automation_account", null), var.automation_account)
  log_verbose              = each.value.log_verbose
  log_progress             = each.value.log_progress
  description              = try(each.value.description, null)
  runbook_type             = each.value.runbook_type
  content                  = try(each.value.content, null)
  log_activity_trace_level = try(each.value.log_activity_trace_level, null)

  tags = try(
    var.config.tags, var.tags, null
  )


  dynamic "publish_content_link" {
    for_each = contains(keys(each.value), "publish_content_link") ? [each.value.publish_content_link] : []

    content {
      uri     = publish_content_link.value.uri
      version = try(publish_content_link.value.version, null)

      dynamic "hash" {
        for_each = lookup(publish_content_link.value, "hash", null) != null ? [publish_content_link.value.hash] : []

        content {
          algorithm = hash.value.algorithm
          value     = hash.value.value
        }
      }
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
          uri     = content_link.value.uri
          version = try(content_link.value.version, null)

          dynamic "hash" {
            for_each = lookup(content_link.value, "hash", null) != null ? [content_link.value.hash] : []

            content {
              algorithm = hash.value.algorithm
              value     = hash.value.value
            }
          }
        }
      }
    }
  }
  lifecycle {
    ignore_changes = [
      job_schedule
    ]
  }
}

# schedules
resource "azurerm_automation_schedule" "schedules" {
  for_each = merge([
    for runbook_key, runbook in var.config : {
      for schedule_key, schedule in try(runbook.schedules, {}) :
      "${runbook_key}-${schedule_key}" => merge(schedule, {
        runbook_key  = runbook_key
        schedule_key = schedule_key
      })
    }
  ]...)

  name                    = try(each.value.name, join("-", [var.naming.automation_schedule, each.key]))
  resource_group_name     = var.resource_group
  automation_account_name = var.automation_account
  frequency               = each.value.frequency
  interval                = each.value.interval
  timezone                = each.value.timezone
  start_time              = each.value.start_time
  description             = try(each.value.description, null)
  week_days               = try(each.value.week_days, null)
  month_days              = try(each.value.month_days, null)
  expiry_time             = try(each.value.expiry_time, null)

  dynamic "monthly_occurrence" {
    for_each = lookup(each.value, "monthly_occurrence", null) != null ? [each.value.monthly_occurrence] : []

    content {
      occurrence = monthly_occurrence.value.occurrence
      day        = monthly_occurrence.value.day
    }
  }
}

# Job Schedules
resource "azurerm_automation_job_schedule" "job_schedules" {
  for_each = merge([
    for runbook_key, runbook in var.config : {
      for schedule_key, schedule in try(runbook.schedules, {}) :
      "${runbook_key}-${schedule_key}" => merge(schedule, {
        runbook_key  = runbook_key
        schedule_key = schedule_key
      })
    }
  ]...)

  resource_group_name     = var.resource_group
  automation_account_name = var.automation_account
  schedule_name           = azurerm_automation_schedule.schedules[each.key].name
  runbook_name            = azurerm_automation_runbook.runbooks[each.value.runbook_key].name
  parameters              = try(each.value.job_schedule_parameters, null)
  run_on                  = try(each.value.run_on, null)
}

resource "azurerm_automation_webhook" "webhooks" {
  for_each = merge([
    for runbook_key, runbook in var.config : {
      for webhook_key, webhook in try(runbook.webhooks, {}) :
      "${runbook_key}-${webhook_key}" => merge(webhook, {
        runbook_key = runbook_key
        webhook_key = webhook_key
      })
    }
  ]...)

  name                    = try(each.value.name, join("-", [var.naming.automation_webhook, each.key]))
  resource_group_name     = coalesce(lookup(var.config, "resource_group", null), var.resource_group)
  automation_account_name = var.automation_account
  runbook_name            = azurerm_automation_runbook.runbooks[each.value.runbook_key].name
  expiry_time             = each.value.expiry_time
  enabled                 = try(each.value.enabled, true)
  run_on_worker_group     = try(each.value.run_on_worker_group, null)
  parameters              = try(each.value.parameters, null)
  uri                     = try(each.value.uri, null)
}
