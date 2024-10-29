output "runbook" {
  description = "contains runbook details"
  value       = azurerm_automation_runbook.runbooks
}

output "webhook" {
  description = "contains webhook details"
  value       = azurerm_automation_webhook.webhooks
}
