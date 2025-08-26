variable "config" {
  description = "contains the runbooks configuration"
  type = map(object({
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

  validation {
    condition = alltrue([
      for runbook_key, runbook in var.config :
      runbook.log_activity_trace_level == null || (runbook.log_activity_trace_level >= 0 && runbook.log_activity_trace_level <= 2)
    ])
    error_message = "log_activity_trace_level must be between 0 and 2 (0=None, 1=Basic, 2=Detailed)."
  }

  validation {
    condition = alltrue([
      for runbook_key, runbook in var.config :
      runbook.publish_content_link == null || can(regex("^https?://", runbook.publish_content_link.uri))
    ])
    error_message = "publish_content_link URI must be a valid HTTP or HTTPS URL."
  }

  validation {
    condition = alltrue([
      for runbook_key, runbook in var.config :
      runbook.publish_content_link == null || runbook.publish_content_link.hash == null || (
        runbook.publish_content_link.hash.algorithm != null &&
        runbook.publish_content_link.hash.value != null &&
        length(runbook.publish_content_link.hash.algorithm) > 0 &&
        length(runbook.publish_content_link.hash.value) > 0
      )
    ])
    error_message = "publish_content_link hash requires both algorithm and value to be non-empty when specified."
  }

  validation {
    condition = alltrue([
      for runbook_key, runbook in var.config :
      runbook.draft == null || runbook.draft.content_link == null || can(regex("^https?://", runbook.draft.content_link.uri))
    ])
    error_message = "draft content_link URI must be a valid HTTP or HTTPS URL."
  }

  validation {
    condition = alltrue([
      for runbook_key, runbook in var.config :
      runbook.draft == null || runbook.draft.parameters == null || alltrue([
        for param_key, param in runbook.draft.parameters : contains([
          "string", "int", "bool", "datetime", "decimal", "object", "array"
        ], param.type)
      ])
    ])
    error_message = "draft parameter type must be one of: string, int, bool, datetime, decimal, object, array."
  }

  validation {
    condition = alltrue(flatten([
      for runbook_key, runbook in var.config : [
        for schedule_key, schedule in(runbook.schedules != null ? runbook.schedules : {}) :
        contains(["Day", "Hour", "Minute", "Month", "OneTime", "Week"], schedule.frequency)
      ]
    ]))
    error_message = "schedule frequency must be one of: Day, Hour, Minute, Month, OneTime, Week."
  }

  validation {
    condition = alltrue(flatten([
      for runbook_key, runbook in var.config : [
        for schedule_key, schedule in(runbook.schedules != null ? runbook.schedules : {}) : (
          (schedule.frequency == "Minute" && schedule.interval >= 1 && schedule.interval <= 1440) ||
          (schedule.frequency == "Hour" && schedule.interval >= 1 && schedule.interval <= 8760) ||
          (schedule.frequency == "Day" && schedule.interval >= 1 && schedule.interval <= 365) ||
          (schedule.frequency == "Week" && schedule.interval >= 1 && schedule.interval <= 52) ||
          (schedule.frequency == "Month" && schedule.interval >= 1 && schedule.interval <= 12) ||
          (schedule.frequency == "OneTime" && schedule.interval == 1)
        )
      ]
    ]))
    error_message = "schedule interval must be valid for frequency: Minute (1-1440), Hour (1-8760), Day (1-365), Week (1-52), Month (1-12), OneTime (1)."
  }

  validation {
    condition = alltrue(flatten([
      for runbook_key, runbook in var.config : [
        for schedule_key, schedule in(runbook.schedules != null ? runbook.schedules : {}) :
        schedule.week_days == null || alltrue([
          for day in schedule.week_days : contains([
            "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"
          ], day)
        ])
      ]
    ]))
    error_message = "schedule week_days must contain valid day names: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday."
  }

  validation {
    condition = alltrue(flatten([
      for runbook_key, runbook in var.config : [
        for schedule_key, schedule in(runbook.schedules != null ? runbook.schedules : {}) :
        schedule.month_days == null || alltrue([
          for day in schedule.month_days : day >= 1 && day <= 31
        ])
      ]
    ]))
    error_message = "schedule month_days must contain values between 1 and 31."
  }

  validation {
    condition = alltrue(flatten([
      for runbook_key, runbook in var.config : [
        for webhook_key, webhook in(runbook.webhooks != null ? runbook.webhooks : {}) :
        can(regex("^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}(\\.\\d{3})?Z?$", webhook.expiry_time))
      ]
    ]))
    error_message = "webhook expiry_time must be in ISO 8601 format (e.g., '2024-12-31T23:59:59.999Z')."
  }
}

variable "location" {
  description = "contains the region"
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "contains the resourcegroup name"
  type        = string
  default     = null
}

variable "automation_account" {
  description = "contains the automation account name"
  type        = string
  default     = null
}

variable "naming" {
  description = "used for naming purposes"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
