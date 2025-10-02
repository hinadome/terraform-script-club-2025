#https://techdocs.akamai.com/terraform/docs/as-rc-configuration
resource "akamai_appsec_configuration" "my_security_configuration" {
  name        = "HI_TerraformCohortAPSConfig"
  description = "This is new configuration for TerraformCohort"
  contract_id = replace(data.akamai_group.my_group.contract_id, "ctr_", "")
  #contract_id = data.akamai_group.my_group.contract_id
  group_id = replace(data.akamai_group.my_group.id, "grp_", "")
  #group_id    = data.akamai_group.my_group.id
  host_names = [tolist(data.akamai_property_hostnames.my_property_hostnames.hostnames[*]["cname_from"])[0]]
  #host_names = ["akamlab.webtechnologists.net"]
}

#https://techdocs.akamai.com/terraform/docs/as-rc-security-policy
resource "akamai_appsec_security_policy" "my_security_policy_1" {
  config_id              = akamai_appsec_configuration.my_security_configuration.id
  default_settings       = true
  security_policy_name   = "Terraformcohortpolicy_1"
  security_policy_prefix = "ter1"
}

resource "akamai_appsec_security_policy" "my_security_policy_2" {
  config_id              = akamai_appsec_configuration.my_security_configuration.id
  default_settings       = true
  security_policy_name   = "Terraformcohortpolicy_2"
  security_policy_prefix = "ter2"
}

