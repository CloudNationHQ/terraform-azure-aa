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


module "automation" {
  source  = "cloudnationhq/aa/azure"
  version = "~> 0.1"

  account = {
    name          = module.naming.automation_account.name
    resourcegroup = module.rg.groups.demo.name
    location      = module.rg.groups.demo.location

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
