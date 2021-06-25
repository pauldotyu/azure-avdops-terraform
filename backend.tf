terraform {
  backend "remote" {
    organization = "pauldotyu"

    workspaces {
      name = "azure-avdops-terraform"
    }
  }
}