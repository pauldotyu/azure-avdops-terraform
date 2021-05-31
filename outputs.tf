output "resource_group_name" {
  value = azurerm_resource_group.wvd.name
}

output "location" {
  value = azurerm_resource_group.wvd.location
}

output "managed_identity_name" {
  value = azurerm_user_assigned_identity.wvd.name
}

output "shared_image_id" {
  value = azurerm_shared_image.wvd.id
}