variable "account" {
  description = "automation account configuration"
  type = object({
    name                          = string
    resource_group_name           = optional(string)
    location                      = optional(string)
    sku_name                      = optional(string, "Basic")
    local_authentication_enabled  = optional(bool)
    public_network_access_enabled = optional(bool)
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
    private_endpoints = optional(map(object({
      name                              = optional(string)
      subnet_resource_id                = string
      subresource_name                  = optional(string)
      private_dns_zone_resource_ids     = optional(list(string))
      private_dns_zone_group_name       = optional(string)
      custom_network_interface_name     = optional(string)
      tags                              = optional(map(string))
      private_service_connection_name   = optional(string)
      private_connection_resource_alias = optional(string)
      is_manual_connection              = optional(bool)
      request_message                   = optional(string)
      ip_configurations = optional(map(object({
        name               = optional(string)
        private_ip_address = optional(string)
        member_name        = optional(string)
        subresource_name   = optional(string)
      })))
    })))
  })

  validation {
    condition     = lookup(var.account, "location", null) != null || var.location != null
    error_message = "location must be set on var.account.location or on the module-level var.location."
  }

  validation {
    condition     = lookup(var.account, "resource_group_name", null) != null || var.resource_group_name != null
    error_message = "resource_group_name must be set on var.account.resource_group_name or on the module-level var.resource_group_name."
  }
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
