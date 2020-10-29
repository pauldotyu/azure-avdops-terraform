provider "azurerm" {
  version = ">= 2.31.1"
  features {}
}

data "azurerm_subscription" "current" {
}


resource "azurerm_resource_group" "aib" {
  name     = "rg-ycc-aib"
  location = "West US 2"
  
  tags = {
    Hello = "There"
    World = "Example"
  }
}

resource "azurerm_role_definition" "aib" {
  name        = "YCC-Image-Creator"
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
    azurerm_resource_group.aib.id
  ]
}

# This assumes you've already created the user assigned managed identity. The principalId is in the output of the identity creation action
resource "azurerm_role_assignment" "aib" {
  scope              = azurerm_resource_group.aib.id
  role_definition_id = azurerm_role_definition.aib.role_definition_resource_id
  principal_id       = "46cdaef3-d9cd-44e3-b3d5-1b30287bb665"
}

resource "azurerm_shared_image_gallery" "aib" {
  name                = "sigycc"
  resource_group_name = azurerm_resource_group.aib.name
  location            = azurerm_resource_group.aib.location
  description         = "Shared images and things."
}

resource "azurerm_shared_image" "aib" {
  name                = "ycc-wvd-image"
  gallery_name        = azurerm_shared_image_gallery.aib.name
  resource_group_name = azurerm_resource_group.aib.name
  location            = azurerm_resource_group.aib.location
  os_type             = "Windows"

  identifier {
    publisher = "FakePublisherName"
    offer     = "FakeOfferName"
    sku       = "Fakeku"
  }
}

# resource "azurerm_shared_image_version" "aib" {
#   name                = "0.0.1"
#   gallery_name        = azurerm_shared_image.aib.gallery_name
#   image_name          = azurerm_shared_image.aib.name
#   resource_group_name = azurerm_shared_image.aib.resource_group_name
#   location            = azurerm_shared_image.aib.location
#   managed_image_id    = azurerm_shared_image.aib.id

#   target_region {
#     name                   = "Central US"
#     regional_replica_count = 1
#     storage_account_type   = "Standard_LRS"
#   }
# }

output "role_definition_id" {
  value = azurerm_role_definition.aib.id
}

output "role_assignment_id" {
  value = azurerm_role_assignment.aib.id
}

output "image_definition_id" {
  value = azurerm_shared_image.aib.id
}