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

variable "rg_wvd_name" {
  type        = string
  description = "Resource group name for WVD deployment"
}

variable "rg_wvd_location" {
  type        = string
  description = "Resource group location for WVD deployment"
}

variable "hp_name" {
  type        = string
  description = "Hostpool name"
}

variable "hp_friendly_name" {
  type        = string
  description = "Hostpool friendly name"
}

variable "hp_description" {
  type        = string
  description = "Hostpool description"
}

variable "dag_name" {
  type        = string
  description = "Desktop Application Group resource name"
}

variable "dag_friendly_name" {
  type        = string
  description = "Desktop Application Group friendly name to display"
}

variable "dag_description" {
  type        = string
  description = "Desktop Application Group description"
}

variable "ws_name" {
  type        = string
  description = "Workspace name"
}

variable "ws_friendly_name" {
  type        = string
  description = "Workspace friendly name"
}

variable "ws_description" {
  type        = string
  description = "Workspace description"
}