output "account" {
  description = "contains automation account details"
  value       = azurerm_automation_account.this
}

output "private_endpoints" {
  description = "private endpoint configuration specifics"
  value       = azurerm_private_endpoint.this
}

output "modules" {
  description = "contains automation module details"
  value       = azurerm_automation_module.this
}

output "powershell72_modules" {
  description = "contains automation powershell 7.2 module details"
  value       = azurerm_automation_powershell72_module.this
}

output "credentials" {
  description = "contains automation credential details"
  value       = azurerm_automation_credential.this
}

output "variables_string" {
  description = "contains automation string variable details"
  value       = azurerm_automation_variable_string.this
}

output "variables_int" {
  description = "contains automation int variable details"
  value       = azurerm_automation_variable_int.this
}

output "variables_bool" {
  description = "contains automation bool variable details"
  value       = azurerm_automation_variable_bool.this
}

output "variables_datetime" {
  description = "contains automation datetime variable details"
  value       = azurerm_automation_variable_datetime.this
}

output "variables_object" {
  description = "contains automation object variable details"
  value       = azurerm_automation_variable_object.this
}
