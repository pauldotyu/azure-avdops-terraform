output "resource_group_name" {
  value = azurerm_resource_group.avd.name
}

output "location" {
  value = azurerm_resource_group.avd.location
}

output "managed_identity_name" {
  value = azurerm_user_assigned_identity.avd.name
}

output "shared_image_id" {
  value = azurerm_shared_image.avd.id
}