# Runbooks

This deploys multiple runbooks along with their corresponding schedules.

## Types

```hcl
runbooks = map(object({
  name         = optional(string)
  runbook_type = string
  log_verbose  = bool
  log_progress = bool
  publish_content_link = optional(object({
    uri = string
  }))
  content = optional(string)
  draft = optional(object({
    content = string
  }))
  schedules = optional(map(object({
    frequency               = string
    interval                = number
    timezone                = string
    start_time              = string
    week_days               = optional(list(string))
    job_schedule_parameters = optional(map(string))
  })))
}))
```

## Notes

The example includes runbooks utilizing publish_content_links, inline content, and draft examples.

The schedules are linked with the associated runbook.
