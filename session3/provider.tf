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
  #edgerc         = var.akamai_edgerc 
  #config_section = var.akamai_edgerc_section
  config {
    client_secret = var.akamai_client_secret
    host          = var.akamai_host
    access_token  = var.akamai_access_token
    client_token  = var.akamai_client_token
    account_key   = var.akamai_account_key
  }
}