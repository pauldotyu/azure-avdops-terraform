variable "location" {
  type        = string
  description = "Resource group location. Make sure you are deploying in a location where Azure Image Builder is supported"
}

variable "tags" {
  type = map(any)
  default = {
    "project" = "gh-avdops-demo"
  }
}

variable "publisher" {
  type        = string
  description = "Image publisher"
}

variable "offer" {
  type        = string
  description = "Image offer"
}

variable "sku" {
  type        = string
  description = "Image SKU"
}