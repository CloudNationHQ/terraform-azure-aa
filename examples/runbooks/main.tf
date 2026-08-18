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
      location = "swedencentral"
    }
  }
}

module "runbooks" {
  source  = "cloudnationhq/aa/azure//modules/runbooks"
  version = "~> 4.0"

  resource_group_name = module.rg.groups.demo.name
  location            = module.rg.groups.demo.location
  automation_account  = module.automation_account.account.name

  runbooks = local.runbooks
}

module "automation_account" {
  source  = "cloudnationhq/aa/azure"
  version = "~> 4.0"

  account = {
    name                = module.naming.automation_account.name_unique
    resource_group_name = module.rg.groups.demo.name
    location            = module.rg.groups.demo.location
  }
}
