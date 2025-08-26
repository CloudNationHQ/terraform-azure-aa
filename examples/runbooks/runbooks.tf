locals {
  runbooks = {
    vm = {
      name         = "Get-AzureVMTutorial" # This should match the workflow name in the linked script
      runbook_type = "PowerShellWorkflow"
      log_verbose  = true
      log_progress = true
      publish_content_link = {
        uri = "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/c4935ffb69246a6058eb24f54640f53f69d3ac9f/101-automation-runbook-getvms/Runbooks/Get-AzureVMTutorial.ps1"
      }
      schedules = {
        daily = {
          frequency  = "Day"
          interval   = 1
          timezone   = "Etc/UTC"
          start_time = "2026-01-01T00:00:00Z"
          job_schedule_parameters = {
            resourcegroup = "rg-demo-dev"
            vmname        = "vm-demo-dev"
          }
        }
        weekly = {
          frequency  = "Week"
          interval   = 1
          timezone   = "Australia/Perth"
          start_time = "2026-08-24T18:00:00+02:00"
          week_days  = ["Friday"]
        }
      }
    }
    hello = {
      runbook_type = "PowerShell"
      log_verbose  = true
      log_progress = true
      content      = <<-EOT
        param(
          [Parameter(Mandatory=$true)]
          [string]$Name
        )

        Write-Output "Hello, $Name! The current time is: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
      EOT
      schedules = {
        daily = {
          frequency  = "Day"
          interval   = 1
          timezone   = "Europe/Amsterdam"
          start_time = "2026-08-24T08:00:00+02:00"
          job_schedule_parameters = {
            name = "admin"
          }
        }
      }
      webhooks = {
        event = {
          expiry_time = "2026-12-31T23:59:59Z"
        }
      }
    }
    draft = {
      runbook_type = "PowerShell"
      log_verbose  = true
      log_progress = true
      draft = {
        content = "Write-Output 'This is a draft runbook with inline content'"
      }
    }
  }
}
