module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 2.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "westeurope"
    }
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 2.0"

  naming = local.naming

  vault = {
    name           = module.naming.key_vault.name_unique
    location       = module.rg.groups.demo.location
    resource_group = module.rg.groups.demo.name

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
  version = "~> 2.0"

  naming = local.naming

  resource_group     = module.rg.groups.demo.name
  location           = module.rg.groups.demo.location
  automation_account = module.automation_account.config.name

  config = local.runbooks
}

module "automation_account" {
  source  = "cloudnationhq/aa/azure"
  version = "~> 2.0"

  naming = local.naming

  config = {
    name           = module.naming.automation_account.name_unique
    resource_group = module.rg.groups.demo.name
    location       = module.rg.groups.demo.location
    modules        = local.modules

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
