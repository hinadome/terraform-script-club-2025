variable "my_contract" {
  description = "my contract of terraform managed infrastructure "
  type        = string
}

variable "my_group" {
  description = "my group of terraform managed infrastructure"
  type        = string
}
variable "my_property_name" {
  type        = string
  description = "Name for the property to be managed"
}

#variable "akamai_provider_config" {
#    description = "Akamai Provider repository"
#    type = string
#    default = ""
#}

variable "my_appsec_targeted_hostnames" {
  description = "Targeted hostnames on appsec config"
  type        = list(string)
  default     = ["akamlab.webtechnologists.net"]
}

variable "akamai_edgerc" {
  description = "Akamai edgerc location"
  type        = string
  default     = "~/.edgerc"
}

variable "akamai_edgerc_section" {
  description = "Akamai edgerc section"
  type        = string
  default     = "terraformclub"
}

variable "akamai_client_secret" {
  type      = string
  sensitive = true
}
variable "akamai_host" {
  type      = string
  sensitive = true

}
variable "akamai_access_token" {
  type      = string
  sensitive = true
}
variable "akamai_client_token" {
  type      = string
  sensitive = true
}
variable "akamai_account_key" {
  type      = string
  sensitive = true
}