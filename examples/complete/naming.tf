locals {
  naming = {
    # lookup outputs to have consistent naming
    for type in local.naming_types : type => lookup(module.naming, type).name
  }

  naming_types = ["key_vault_secret", "automation_variable", "automation_credential", "automation_runbook", "automation_schedule"]
}
