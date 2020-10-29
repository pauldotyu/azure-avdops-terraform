variable "rg_name" {
  type        = string
  description = "(optional) describe your variable"
  default     = "rg-ycc-aib"
}

variable "rg_location" {
  type        = string
  description = "(optional) describe your variable"
  default     = "West US 2"
}

variable "role_def_name" {
  type        = string
  description = "(optional) describe your variable"
  default     = "YCC-Image-Creator"
}

variable "role_def_description" {
  type        = string
  description = "(optional) describe your variable"
  default     = "Azure Image Builder access to create resources for the image build"
}

variable "role_assignment_principal_id" {
  type        = string
  description = "(optional) describe your variable"
}

variable "sig_name" {
  type        = string
  description = "(optional) describe your variable"
  default     = "sigycc"
}

variable "sig_description" {
  type        = string
  description = "(optional) describe your variable"
  default     = "Shared images and things."
}

variable "sig_image_name" {
  type        = string
  description = "(optional) describe your variable"
  default     = "ycc-wvd-image"
}

variable "sig_publisher" {
  type        = string
  description = "(optional) describe your variable"
  default     = "FakePublisherName"
}

variable "sig_offer" {
  type        = string
  description = "(optional) describe your variable"
  default     = "FakeOfferName"
}

variable "sig_sku" {
  type        = string
  description = "(optional) describe your variable"
  default     = "Fakeku"
}