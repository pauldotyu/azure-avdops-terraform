provider "azurerm" {
  version = ">= 2.31.1"
  features {}
}

##############################################
# WINDOWS VIRTUAL DESKTOP 
##############################################

resource "azurerm_resource_group" "wvd" {
  name     = var.rg_wvd_name
  location = var.rg_wvd_location

  tags = {
    environment = "dev"
  }
}

resource "azurerm_virtual_desktop_host_pool" "wvd" {
  name                 = var.hp_name
  resource_group_name  = azurerm_resource_group.wvd.name
  location             = azurerm_resource_group.wvd.location
  type                 = "Pooled"
  load_balancer_type   = "BreadthFirst"
  friendly_name        = var.hp_friendly_name
  description          = var.hp_description
  validate_environment = false

  registration_info {
    expiration_date = timeadd(timestamp(), "200m")
  }
}

resource "azurerm_virtual_desktop_application_group" "wvd" {
  name                = var.rag_name
  location            = azurerm_resource_group.wvd.location
  resource_group_name = azurerm_resource_group.wvd.name
  host_pool_id        = azurerm_virtual_desktop_host_pool.wvd.id
  type                = "RemoteApp"
  friendly_name       = var.rag_friendly_name
  description         = var.rag_description
}

resource "azurerm_virtual_desktop_workspace" "wvd" {
  name                = var.ws_name
  location            = azurerm_resource_group.wvd.location
  resource_group_name = azurerm_resource_group.wvd.name
  friendly_name       = var.ws_friendly_name
  description         = var.ws_description
}

resource "azurerm_virtual_desktop_workspace_application_group_association" "wvd" {
  workspace_id         = azurerm_virtual_desktop_workspace.wvd.id
  application_group_id = azurerm_virtual_desktop_application_group.wvd.id
}

# Build session hosts using this: https://github.com/Azure/RDS-Templates/tree/master/wvd-sh/terraform-azurerm-windowsvirtualdesktop

##############################################
# OUTPUTS
##############################################

output "hostpool_reg_token" {
  value = azurerm_virtual_desktop_host_pool.wvd.registration_info[0].token
}