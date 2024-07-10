locals {
  modules = {
    xactivedirectory = {
      uri = "https://www.powershellgallery.com/api/v2/package/xActiveDirectory/2.19.0"
    }
    pester = {
      uri  = "https://www.powershellgallery.com/api/v2/package/pester/"
      type = "powershell72"
    }
    pswindowsupdate = {
      uri  = "https://www.powershellgallery.com/api/v2/package/PSWindowsUpdate/2.2.0.3"
      type = "powershell72"
    }
    carbon = {
      uri  = "https://www.powershellgallery.com/api/v2/package/Carbon/2.12.0"
      type = "powershell72"
    }
    psscriptanalyzer = {
      uri  = "https://www.powershellgallery.com/api/v2/package/PSScriptAnalyzer/1.21.0"
      type = "powershell72"
    }
    networkingdsc = {
      uri  = "https://www.powershellgallery.com/api/v2/package/NetworkingDsc/9.0.0"
      type = "powershell72"
    }
  }
}
