locals {
  flattened_schedules = merge([
    for runbook_key, runbook in var.runbooks : {
      for schedule_key, schedule in try(runbook.schedules, {}) :
      "${runbook_key}-${schedule_key}" => merge(schedule, {
        runbook_key  = runbook_key
        schedule_key = schedule_key
      })
    }
  ]...)
}
