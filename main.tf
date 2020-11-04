provider "azurerm" {
  version = ">= 2.31.1"
  features {}
}

##############################################
# AZURE IMAGE BUILDER
##############################################

data "azurerm_subscription" "current" {
}

resource "azurerm_resource_group" "aib" {
  name     = var.rg_aib_name
  location = var.rg_aib_location

  tags = {
    environment = "dev"
  }
}

resource "azurerm_user_assigned_identity" "aib" {
  resource_group_name = azurerm_resource_group.aib.name
  location            = azurerm_resource_group.aib.location

  name = var.ua_managed_identity_name
}

resource "azurerm_role_definition" "aib" {
  name        = var.role_def_name
  scope       = data.azurerm_subscription.current.id
  description = "Azure Image Builder access to create resources for the image build"

  permissions {
    actions = [
      "Microsoft.Compute/galleries/read",
      "Microsoft.Compute/galleries/images/read",
      "Microsoft.Compute/galleries/images/versions/read",
      "Microsoft.Compute/galleries/images/versions/write",
      "Microsoft.Compute/images/write",
      "Microsoft.Compute/images/read",
      "Microsoft.Compute/images/delete"
    ]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.current.id,
    azurerm_resource_group.aib.id
  ]
}

resource "azurerm_role_assignment" "aib" {
  scope              = azurerm_resource_group.aib.id
  role_definition_id = azurerm_role_definition.aib.role_definition_resource_id
  principal_id       = azurerm_user_assigned_identity.aib.principal_id
}

resource "azurerm_shared_image_gallery" "aib" {
  name                = var.sig_name
  resource_group_name = azurerm_resource_group.aib.name
  location            = azurerm_resource_group.aib.location
  description         = "Shared images and things."
}

resource "azurerm_shared_image" "aib" {
  name                = var.sig_image_name
  gallery_name        = azurerm_shared_image_gallery.aib.name
  resource_group_name = azurerm_resource_group.aib.name
  location            = azurerm_resource_group.aib.location
  os_type             = "Windows"

  identifier {
    publisher = var.sig_publisher
    offer     = var.sig_offer
    sku       = var.sig_sku
  }
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

# resource "azurerm_virtual_desktop_application_group" "rag" {
#   name                = "rag-contoso-computerlab"
#   location            = azurerm_resource_group.wvd.location
#   resource_group_name = azurerm_resource_group.wvd.name
#   host_pool_id        = azurerm_virtual_desktop_host_pool.wvd.id
#   type                = "RemoteApp"
#   friendly_name       = "Remote Apps"
#   description         = "Remote applications for student use"
# }

resource "azurerm_virtual_desktop_application_group" "dag" {
  name                = var.dag_name
  location            = azurerm_resource_group.wvd.location
  resource_group_name = azurerm_resource_group.wvd.name
  host_pool_id        = azurerm_virtual_desktop_host_pool.wvd.id
  type                = "Desktop"
  friendly_name       = var.dag_friendly_name
  description         = var.dag_description
}

resource "azurerm_virtual_desktop_workspace" "wvd" {
  name                = var.ws_name
  location            = azurerm_resource_group.wvd.location
  resource_group_name = azurerm_resource_group.wvd.name
  friendly_name       = var.ws_friendly_name
  description         = var.ws_description
}

# resource "azurerm_virtual_desktop_workspace_application_group_association" "workspaceremoteapp" {
#   workspace_id         = azurerm_virtual_desktop_workspace.wvd.id
#   application_group_id = azurerm_virtual_desktop_application_group.rag.id
# }

resource "azurerm_virtual_desktop_workspace_application_group_association" "workspacedesktopapp" {
  workspace_id         = azurerm_virtual_desktop_workspace.wvd.id
  application_group_id = azurerm_virtual_desktop_application_group.dag.id
}

# Build session hosts using this: https://github.com/Azure/RDS-Templates/tree/master/wvd-sh/terraform-azurerm-windowsvirtualdesktop

##############################################
# OUTPUTS
##############################################

output "hostpool_reg_token" {
  value = azurerm_virtual_desktop_host_pool.wvd.registration_info[0].token
}


output "role_definition_id" {
  value = azurerm_role_definition.aib.id
}

output "role_assignment_id" {
  value = azurerm_role_assignment.aib.id
}

output "image_definition_id" {
  value = azurerm_shared_image.aib.id
}