/*  

output "contact_types" {
  value = data.akamai_iam_contact_types.my_contact_types.contact_types
}

output "group_ids" {
  value = data.akamai_iam_groups.my_groups.groups.*.group_id
}

output "group" {
  value = data.akamai_iam_group.my_group
}

output "my_groups" {
  value = data.akamai_groups.my_groups
}

output "my_contracts" {
  value = data.akamai_contracts.my_contracts
}

output "my_contract" {
  value = data.akamai_contract.my_contract
}

output "akamai_properties" {
  value = data.akamai_properties.my_properties
}
*/

output "my_group" {
  value = data.akamai_group.my_group
}

output "configuration" {
  value = data.akamai_appsec_configuration.configuration
}

output "akamai_property" {
  value = data.akamai_property.my_property
}