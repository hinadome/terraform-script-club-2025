output "my_property" {
  value = data.akamai_property.my_property
}

output "my_terraform_property" {
  value = akamai_property.my_terraform_property
}

output "my_appsec_configuration" {
  value = data.akamai_appsec_configuration.my_appsec_configuration
}

output "my_security_configuration" {
  value = akamai_appsec_configuration.my_terraform_appsec_config
}

output "my_security_policy_1" {
  value = akamai_appsec_security_policy.my_terraform_sec_policy_1
}

output "my_security_policy_2" {
  value = akamai_appsec_security_policy.my_terraform_sec_policy_2
}

#output "my_groups" {
#  value = data.akamai_groups.my_groups
#}

#output "my_group_names" {
#  value = data.akamai_groups.my_groups.groups.*.group_name
#}

#output "my_group" {
#  value = var.my_group
#}

#output "my_contracts" {
#  value = data.akamai_contracts.my_contracts
#}

#output "my_contract" {
#  value =  data.akamai_contract.my_contract
#}

#output "my_properties" {
#  value = data.akamai_properties.my_properties
#}

#output "my_property_hostnames" {
#  value = data.akamai_property_hostnames.my_property_hostnames.hostnames[*]["cname_from"]
#}

#output "my_property_hostname" {
#  value = tolist(data.akamai_property_hostnames.my_property_hostnames.hostnames[*]["cname_from"])[0]
#}

#output "all_appsec_configurations" {
#  value = data.akamai_appsec_configuration.all_configurations.output_text
#}