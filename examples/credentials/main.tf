module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.25"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 3.0"

  groups = {
    demo = {
      name     = module.naming.resource_group.name_unique
      location = "germanywestcentral"
    }
  }
}

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 6.0"

  vault = {
    name                = module.naming.key_vault.name_unique
    location            = module.rg.groups.demo.location
    resource_group_name = module.rg.groups.demo.name

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

module "automation_account" {
  source  = "cloudnationhq/aa/azure"
  version = "~> 4.0"

  account = {
    name                = module.naming.automation_account.name_unique
    resource_group_name = module.rg.groups.demo.name
    location            = module.rg.groups.demo.location

    credentials = {
      admin = {
        username = "admin"
        password = module.kv.secrets.demo.value
      }
    }
  }
}
