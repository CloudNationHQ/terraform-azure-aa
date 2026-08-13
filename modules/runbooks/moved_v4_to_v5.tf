moved {
  from = azurerm_automation_runbook.runbooks
  to   = azurerm_automation_runbook.this
}

moved {
  from = azurerm_automation_schedule.schedules
  to   = azurerm_automation_schedule.this
}

moved {
  from = azurerm_automation_job_schedule.job_schedules
  to   = azurerm_automation_job_schedule.this
}

moved {
  from = azurerm_automation_webhook.webhooks
  to   = azurerm_automation_webhook.this
}
