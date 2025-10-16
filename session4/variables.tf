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

variable "ab_test" {
  description = "Origin A/B Test value"
  type        = string
  default     = "A"
}

variable "apps" {
  description = "Exercise for iterations"
  type        = list(string)
  default     = ["www", "api", "blog", "shop", "cdn"]
}

variable "dns_records" {
  description = "Excercise for each"
  default = {
    "origin1" = {
      zone       = "dnslab.webtechnologists.net"
      recordType = "A"
      ttl        = 60
      target     = "172.233.190.92"
      name       = "origin-www.terraform.dnslab.webtechnologists.net"
    },
    "origin2" = {
      zone       = "dnslab.webtechnologists.net"
      recordType = "A"
      ttl        = 100
      target     = "173.233.190.93"
      name       = "origin-api.terraform.dnslab.webtechnologists.net"
    },
    "origin3" = {
      zone       = "dnslab.webtechnologists.net"
      recordType = "A"
      ttl        = 600
      target     = "174.233.190.94"
      name       = "origin-blog.terraform.dnslab.webtechnologists.net"
    }
  }
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