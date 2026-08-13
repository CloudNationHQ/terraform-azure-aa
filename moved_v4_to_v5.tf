moved {
  from = azurerm_automation_account.aa
  to   = azurerm_automation_account.this
}

moved {
  from = azurerm_automation_module.mod
  to   = azurerm_automation_module.this
}

moved {
  from = azurerm_automation_powershell72_module.modpwsh72
  to   = azurerm_automation_powershell72_module.this
}

moved {
  from = azurerm_automation_credential.creds
  to   = azurerm_automation_credential.this
}

moved {
  from = azurerm_automation_variable_string.variables
  to   = azurerm_automation_variable_string.this
}

moved {
  from = azurerm_automation_variable_int.variables
  to   = azurerm_automation_variable_int.this
}

moved {
  from = azurerm_automation_variable_bool.variables
  to   = azurerm_automation_variable_bool.this
}

moved {
  from = azurerm_automation_variable_datetime.variables
  to   = azurerm_automation_variable_datetime.this
}

moved {
  from = azurerm_automation_variable_object.variables
  to   = azurerm_automation_variable_object.this
}
