#Excecise
locals {
  app_hostnames = [for app in var.apps : "${app}.terraform.dnslab.webtechnologists.net"]
}

#https://techdocs.akamai.com/terraform/docs/as-ds-configuration
data "akamai_appsec_configuration" "my_appsec_configuration" {
  name = "HI_TerraformCohortAPSConfig"
}

#Using hostname for appsec config 
#https://techdocs.akamai.com/terraform/docs/pm-ds-property
data "akamai_property" "my_property" {
  name    = "hinadome-test-secure-by-default"
  version = "81"
}

data "akamai_property_hostnames" "my_property_hostnames" {
  contract_id = var.my_contract
  group_id    = var.my_group
  property_id = data.akamai_property.my_property.id
  version     = data.akamai_property.my_property.version
}


#data "akamai_contracts" "my_contracts" {
#}

#data "akamai_contract" "my_contract" {
#  group_name = "Akamai Professional Services-1-1NC95D"
#}

#data "akamai_groups" "my_groups" {}

#data "akamai_group" "my_group" {
#  group_name  = "Akamai Professional Services-1-1NC95D"
#  contract_id = "ctr_1-1NC95D"
#}

#https://techdocs.akamai.com/terraform/docs/pm-ds-properties
#data "akamai_properties" "my_properties" {
#  contract_id = data.akamai_group.my_group.contract_id
#  group_id    = data.akamai_group.my_group.id
#}

#data "akamai_property_rules" "my_property_rules" {
#    property_id = akamai_property.my_terraform_property.id 
#    version     = 1 
#    group_id    = akamai_property.my_terraform_property.group_id
#    contract_id = akamai_property.my_terraform_property.contract_id
#}
