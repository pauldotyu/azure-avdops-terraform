provider "azurerm" {
  features {}
}

resource "random_pet" "avd" {
  length    = 2
  separator = ""
}

data "azurerm_subscription" "current" {}

##############################################
# AZURE IMAGE BUILDER
##############################################

resource "azurerm_resource_group" "avd" {
  name     = "rg-${random_pet.avd.id}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_user_assigned_identity" "avd" {
  name                = "msi-${random_pet.avd.id}"
  resource_group_name = azurerm_resource_group.avd.name
  location            = azurerm_resource_group.avd.location
  tags                = var.tags
}

resource "azurerm_role_definition" "avd" {
  name        = "role-${random_pet.avd.id}"
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
    azurerm_resource_group.avd.id
  ]
}

resource "azurerm_role_assignment" "avd" {
  scope              = azurerm_resource_group.avd.id
  role_definition_id = azurerm_role_definition.avd.role_definition_resource_id
  principal_id       = azurerm_user_assigned_identity.avd.principal_id
}

resource "azurerm_shared_image_gallery" "avd" {
  name                = "sig${random_pet.avd.id}"
  resource_group_name = azurerm_resource_group.avd.name
  location            = azurerm_resource_group.avd.location
  tags                = var.tags
}

resource "azurerm_shared_image" "avd" {
  name                = "avd-${random_pet.avd.id}"
  gallery_name        = azurerm_shared_image_gallery.avd.name
  resource_group_name = azurerm_resource_group.avd.name
  location            = azurerm_resource_group.avd.location
  os_type             = "Windows"
  hyper_v_generation  = "V2"

  identifier {
    publisher = var.publisher
    offer     = var.offer
    sku       = "avd-${random_pet.avd.id}"
  }
}

##############################################
# AZURE FILES
##############################################

resource "azurerm_storage_account" "avd" {
  name                     = "sa${random_pet.avd.id}"
  resource_group_name      = azurerm_resource_group.avd.name
  location                 = azurerm_resource_group.avd.location
  account_tier             = "Premium"
  account_kind             = "FileStorage"
  account_replication_type = "LRS"
  allow_blob_public_access = false
}

resource "azurerm_storage_share" "avd" {
  name                 = "profiles"
  storage_account_name = azurerm_storage_account.avd.name
  quota                = 100
}