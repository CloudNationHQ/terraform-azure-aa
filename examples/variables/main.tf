module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 0.1"

  groups = {
    demo = {
      name   = module.naming.resource_group.name
      region = "westeurope"
    }
  }
}

module "aa" {
  source  = "cloudnationhq/aa/azure"
  version = "~> 0.1"

  naming = local.naming

  account = {
    name          = module.naming.automation_account.name
    resourcegroup = module.rg.groups.demo.name
    location      = module.rg.groups.demo.location

    variables = {
      maintenance_status = {
        value = false
      },
      maintenance_message = {
        value = "Down for maintenance. Be right back."
      },
      retry_count = {
        value = 3
      },
      last_maintenance = {
        value = "2023-04-01T00:00:00Z"
      },
      api_config = {
        value = {
          endpoint = "https://api.example.com/v1"
          retries  = 3
        }
      },
      feature_flags = {
        value = {
          enable_new_ui = true
          beta_features = ["feature1", "feature2"]
        }
      }
    }
  }
}
