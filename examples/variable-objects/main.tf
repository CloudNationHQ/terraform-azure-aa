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
      maintenance = {
        value = {
          status  = false
          message = "Down for maintenance. Be right back."
        }
      },
      api = {
        value = {
          endpoint = "https://api.example.com/v1"
          retries  = 3
        }
      }
    }
  }
}
