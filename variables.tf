variable "rg_name" {
  type        = string
  description = "Resource group name for Shared Image Gallery"
}

variable "rg_location" {
  type        = string
  description = "Resource group location. Make sure you are deploying in a location where Azure Image Builder is supported"
}

variable "role_def_name" {
  type        = string
  description = "Role definition name"
}

variable "role_def_description" {
  type        = string
  description = "Role defintion description"
}

variable "role_assignment_principal_id" {
  type        = string
  description = "User assigned managed identity ID"
}

variable "sig_name" {
  type        = string
  description = "Shared Image Gallery name"
}

variable "sig_description" {
  type        = string
  description = "Shared Image Gallery description"
}

variable "sig_image_name" {
  type        = string
  description = "Image name"
}

variable "sig_publisher" {
  type        = string
  description = "Image publisher"
}

variable "sig_offer" {
  type        = string
  description = "Image offer"
}

variable "sig_sku" {
  type        = string
  description = "Image SKU"
}