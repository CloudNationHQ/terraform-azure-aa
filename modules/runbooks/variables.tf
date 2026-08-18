variable "runbooks" {
  description = "contains the runbooks configuration"
  type = map(object({
    name                     = optional(string)
    description              = optional(string)
    content                  = optional(string)
    log_activity_trace_level = optional(number)
    runtime_environment_name = optional(string)
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
      job_schedule_id         = optional(string)
    })))
    webhooks = optional(map(object({
      expiry_time         = string
      name                = optional(string)
      enabled             = optional(bool)
      run_on_worker_group = optional(string)
      parameters          = optional(map(string))
      uri                 = optional(string)
    })))
  }))
}

variable "location" {
  description = "contains the region"
  type        = string
  default     = null

  validation {
    condition     = var.location != null
    error_message = "location must be set."
  }
}

variable "resource_group_name" {
  description = "contains the resourcegroup name"
  type        = string
  default     = null

  validation {
    condition     = var.resource_group_name != null
    error_message = "resource_group_name must be set."
  }
}

variable "automation_account" {
  description = "contains the automation account name"
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
