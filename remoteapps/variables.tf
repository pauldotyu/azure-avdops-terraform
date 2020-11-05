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

variable "rag_name" {
  type        = string
  description = "Desktop Application Group resource name"
}

variable "rag_friendly_name" {
  type        = string
  description = "Remote Application Group friendly name to display"
}

variable "rag_description" {
  type        = string
  description = "Remote Application Group description"
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