terraform {
  required_providers {
    akamai = {
      source  = "akamai/akamai"
      version = ">= 6.1.0"
    }
  }
  required_version = ">= 1.8"
}

#https://registry.terraform.io/providers/akamai/akamai/latest/docs
provider "akamai" {
  edgerc         = "~/.edgerc"
  config_section = "terraformclub"
}
