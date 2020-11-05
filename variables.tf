variable "rg_aib_name" {
  type        = string
  description = "Resource group name for Azure Image Builder"
}

variable "rg_aib_location" {
  type        = string
  description = "Resource group location. Make sure you are deploying in a location where Azure Image Builder is supported"
}

variable "ua_managed_identity_name" {
  type        = string
  description = "Name for user assigned managed identity"
}

variable "role_def_name" {
  type        = string
  description = "Role definition name"
}

variable "sig_name" {
  type        = string
  description = "Shared Image Gallery name"
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