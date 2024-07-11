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

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 0.1"

  naming = local.naming

  vault = {
    name          = module.naming.key_vault.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

    secrets = {
      random_string = {
        demo = {
          length  = 24
          special = false
        }
      }
    }
  }
}

module "runbooks" {
  source  = "cloudnationhq/aa/azure//modules/runbooks"
  version = "~> 0.1"

  naming = local.naming

  resourcegroup      = module.rg.groups.demo.name
  location           = module.rg.groups.demo.location
  automation_account = module.automation.account.name

  runbooks = local.runbooks
}

module "automation" {
  source  = "cloudnationhq/aa/azure"
  version = "~> 0.1"

  naming = local.naming

  account = {
    name          = module.naming.automation_account.name
    resourcegroup = module.rg.groups.demo.name
    location      = module.rg.groups.demo.location
    modules       = local.modules

    variables = {
      maintenance = {
        value = {
          status  = false
          message = "Down for maintenance"
        }
      }
    }

    credentials = {
      admin = {
        username = "admin"
        password = module.kv.secrets.demo.value
      }
    }
  }
}
