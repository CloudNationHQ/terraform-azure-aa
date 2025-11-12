variable "config" {
  description = "automation account configuration"
  type = object({
    name                          = string
    resource_group_name           = optional(string)
    location                      = optional(string)
    sku_name                      = optional(string, "Basic")
    local_authentication_enabled  = optional(bool, true)
    public_network_access_enabled = optional(bool, true)
    tags                          = optional(map(string))
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    encryption = optional(object({
      key_vault_key_id          = string
      user_assigned_identity_id = optional(string)
    }))
    modules = optional(map(object({
      uri  = string
      name = optional(string)
      type = optional(string)
      hash = optional(object({
        algorithm = string
        value     = string
      }))
    })), {})
    credentials = optional(map(object({
      username    = string
      password    = string
      name        = optional(string)
      description = optional(string)
    })), {})
    variables = optional(any, {})
  })

  validation {
    condition     = var.config.location != null || var.location != null
    error_message = "location must be provided either in the object or as a separate variable."
  }

  validation {
    condition     = var.config.resource_group_name != null || var.resource_group_name != null
    error_message = "resource group name must be provided either in the  object or as a separate variable."
  }

  validation {
    condition = var.config.identity == null || var.config.identity.type != "UserAssigned" || (
      var.config.identity.identity_ids != null && length(var.config.identity.identity_ids) > 0
    )
    error_message = "Identity IDs are required when using UserAssigned identity type."
  }

  validation {
    condition     = var.config.encryption == null || var.config.identity != null
    error_message = "Identity configuration is required when encryption is enabled."
  }

  validation {
    condition = var.config.encryption == null || (
      var.config.encryption.user_assigned_identity_id != null ?
      can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft.ManagedIdentity/userAssignedIdentities/[^/]+$", var.config.encryption.user_assigned_identity_id)) :
      true
    )
    error_message = "Encryption user assigned identity ID must be a valid ARM resource ID for a managed identity."
  }

  validation {
    condition = var.config.modules == null || alltrue([
      for module_key, module_value in var.config.modules :
      can(regex("^https?://", module_value.uri))
    ])
    error_message = "Module URI must be a valid HTTP or HTTPS URL."
  }

  validation {
    condition = var.config.modules == null || alltrue([
      for module_key, module_value in var.config.modules :
      module_value.hash == null || (
        module_value.hash.algorithm != null &&
        module_value.hash.value != null &&
        length(module_value.hash.algorithm) > 0 &&
        length(module_value.hash.value) > 0
      )
    ])
    error_message = "Module hash requires both algorithm and value to be non-empty when specified."
  }

  validation {
    condition = var.config.credentials == null || alltrue([
      for cred_key, cred_value in var.config.credentials :
      length(cred_value.username) > 0 && length(cred_value.password) > 0
    ])
    error_message = "Credential username and password cannot be empty."
  }

  validation {
    condition = var.config.credentials == null || alltrue([
      for cred_key, cred_value in var.config.credentials :
      length(cred_value.username) <= 64
    ])
    error_message = "Credential username cannot exceed 64 characters."
  }
}

variable "naming" {
  description = "contains naming convention"
  type        = map(string)
  default     = {}
}

variable "location" {
  description = "default azure region to be used."
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "default resource group to be used."
  type        = string
  default     = null
}

variable "tags" {
  description = "tags to be added to the resources"
  type        = map(string)
  default     = {}
}
