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
      name     = module.naming.resource_group.name
      location = "westeurope"
    }
  }
}


module "automation_account" {
  source  = "cloudnationhq/aa/azure"
  version = "~> 2.0"

  config = {
    name           = module.naming.automation_account.name
    resource_group = module.rg.groups.demo.name
    location       = module.rg.groups.demo.location

    modules = {
      xactivedirectory = {
        uri = "https://www.powershellgallery.com/api/v2/package/xActiveDirectory/2.19.0"
      }
      pester = {
        uri  = "https://www.powershellgallery.com/api/v2/package/pester/"
        type = "powershell72"
      }
    }
  }
}
