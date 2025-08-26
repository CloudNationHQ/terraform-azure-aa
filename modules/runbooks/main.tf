resource "azurerm_automation_runbook" "runbooks" {
  for_each = var.config

  name = coalesce(
    each.value.name, try(
      join("-", [var.naming.automation_runbook, each.key]), null
    ), each.key
  )

  resource_group_name      = var.resource_group_name
  location                 = var.location
  automation_account_name  = var.automation_account
  log_verbose              = each.value.log_verbose
  log_progress             = each.value.log_progress
  description              = each.value.description
  runbook_type             = each.value.runbook_type
  content                  = each.value.content
  log_activity_trace_level = each.value.log_activity_trace_level

  tags = var.tags


  dynamic "publish_content_link" {
    for_each = each.value.publish_content_link != null ? [each.value.publish_content_link] : []

    content {
      uri     = publish_content_link.value.uri
      version = publish_content_link.value.version

      dynamic "hash" {
        for_each = publish_content_link.value.hash != null ? [publish_content_link.value.hash] : []

        content {
          algorithm = hash.value.algorithm
          value     = hash.value.value
        }
      }
    }
  }

  dynamic "draft" {
    for_each = each.value.draft != null ? [each.value.draft] : []

    content {
      edit_mode_enabled = draft.value.edit_mode_enabled
      output_types      = draft.value.output_types

      dynamic "parameters" {
        for_each = draft.value.parameters != null ? draft.value.parameters : {}

        content {
          key           = parameters.key
          type          = parameters.value.type
          mandatory     = parameters.value.mandatory
          position      = parameters.value.position
          default_value = parameters.value.default_value
        }
      }

      dynamic "content_link" {
        for_each = draft.value.content_link != null ? [draft.value.content_link] : []

        content {
          uri     = content_link.value.uri
          version = content_link.value.version

          dynamic "hash" {
            for_each = content_link.value.hash != null ? [content_link.value.hash] : []

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
      for schedule_key, schedule in(runbook.schedules != null ? runbook.schedules : {}) :
      "${runbook_key}-${schedule_key}" => merge(schedule, {
        runbook_key  = runbook_key
        schedule_key = schedule_key
      })
    }
  ]...)

  name                    = coalesce(each.value.name, join("-", [var.naming.automation_schedule, each.key]))
  resource_group_name     = var.resource_group_name
  automation_account_name = var.automation_account
  frequency               = each.value.frequency
  interval                = each.value.interval
  timezone                = each.value.timezone
  start_time              = each.value.start_time
  description             = each.value.description
  week_days               = each.value.week_days
  month_days              = each.value.month_days
  expiry_time             = each.value.expiry_time

  dynamic "monthly_occurrence" {
    for_each = each.value.monthly_occurrence != null ? [each.value.monthly_occurrence] : []

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
      for schedule_key, schedule in(runbook.schedules != null ? runbook.schedules : {}) :
      "${runbook_key}-${schedule_key}" => merge(schedule, {
        runbook_key  = runbook_key
        schedule_key = schedule_key
      })
    }
  ]...)

  resource_group_name     = var.resource_group_name
  automation_account_name = var.automation_account
  schedule_name           = azurerm_automation_schedule.schedules[each.key].name
  runbook_name            = azurerm_automation_runbook.runbooks[each.value.runbook_key].name
  parameters              = each.value.job_schedule_parameters
  run_on                  = each.value.run_on
}

resource "azurerm_automation_webhook" "webhooks" {
  for_each = merge([
    for runbook_key, runbook in var.config : {
      for webhook_key, webhook in(runbook.webhooks != null ? runbook.webhooks : {}) :
      "${runbook_key}-${webhook_key}" => merge(webhook, {
        runbook_key = runbook_key
        webhook_key = webhook_key
      })
    }
  ]...)

  name                    = coalesce(each.value.name, join("-", [var.naming.automation_webhook, each.key]))
  resource_group_name     = var.resource_group_name
  automation_account_name = var.automation_account
  runbook_name            = azurerm_automation_runbook.runbooks[each.value.runbook_key].name
  expiry_time             = each.value.expiry_time
  enabled                 = each.value.enabled
  run_on_worker_group     = each.value.run_on_worker_group
  parameters              = each.value.parameters
  uri                     = each.value.uri
}
