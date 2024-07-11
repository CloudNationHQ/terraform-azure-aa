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

  account = {
    name          = module.naming.automation_account.name
    resourcegroup = module.rg.groups.demo.name
    location      = module.rg.groups.demo.location
  }
}
