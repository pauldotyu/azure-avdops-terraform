output "role_definition_id" {
  value = azurerm_role_definition.wvd.id
}

output "role_assignment_id" {
  value = azurerm_role_assignment.wvd.id
}

output "image_definition_id" {
  value = azurerm_shared_image.wvd.id
}