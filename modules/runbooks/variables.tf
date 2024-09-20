variable "config" {
  description = "contains the runbooks configuration"
  type        = any
}

variable "location" {
  description = "contains the region"
  type        = string
  default     = null
}

variable "resource_group" {
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
