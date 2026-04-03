output "config" {
  description = "contains automation account details"
  value       = azurerm_automation_account.aa
}

output "modules" {
  description = "contains automation module details"
  value       = azurerm_automation_module.mod
}

output "powershell72_modules" {
  description = "contains automation powershell 7.2 module details"
  value       = azurerm_automation_powershell72_module.modpwsh72
}

output "credentials" {
  description = "contains automation credential details"
  value       = azurerm_automation_credential.creds
}

output "variables_string" {
  description = "contains automation string variable details"
  value       = azurerm_automation_variable_string.variables
}

output "variables_int" {
  description = "contains automation int variable details"
  value       = azurerm_automation_variable_int.variables
}

output "variables_bool" {
  description = "contains automation bool variable details"
  value       = azurerm_automation_variable_bool.variables
}

output "variables_datetime" {
  description = "contains automation datetime variable details"
  value       = azurerm_automation_variable_datetime.variables
}

output "variables_object" {
  description = "contains automation object variable details"
  value       = azurerm_automation_variable_object.variables
}
