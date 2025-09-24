/*
https://techdocs.akamai.com/terraform/docs/breaking-changes

data "akamai_iam_contact_types" "my_contact_types" {}

#https://techdocs.akamai.com/terraform/docs/iam-ds-groups
data "akamai_iam_groups" "my_groups" {}

data "akamai_iam_group" "my_group" {
  group_id = data.akamai_iam_groups.my_groups.groups.*.group_id[0]
}

// Get all
#data "akamai_contracts" "my_contracts" {
#}

// Get one
#data "akamai_contract" "my_contract" {
#  group_name = "Test BSS Knowledge"
#}

// Akamai Properties
#data "akamai_properties" "my_properties" {
#  group_id    = "grp_18388"
#  contract_id = "ctr_1-3CV382"
#}
*/

// akamai_group, referencing a single group.
// Get all
#data "akamai_groups" "my_groups" {
#}
// Get one
data "akamai_group" "my_group" {
  group_name  = "Test BSS Knowledge"
  contract_id = "ctr_1-3CV382"
}

// akamai_appsec_configuration, referencing a single config
data "akamai_appsec_configuration" "configuration" {
  name = "AHSecTest"
}

//akamai_property, referencing a single Akamai property
data "akamai_property" "my_property" {
  name    = "test.learn"
  version = "1"
}