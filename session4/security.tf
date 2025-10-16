#https://techdocs.akamai.com/terraform/docs/as-rc-configuration
resource "akamai_appsec_configuration" "my_terraform_appsec_config" {
  name        = "HI_TerraformCohortAPSConfig"
  description = "This is new configuration for TerraformCohort"
  contract_id = local.my_contract_id
  group_id    = local.my_group_id
  host_names  = var.my_appsec_targeted_hostnames
  #host_names = [tolist(data.akamai_property_hostnames.my_property_hostnames.hostnames[*]["cname_from"])[0]]
}

#https://techdocs.akamai.com/terraform/docs/as-rc-security-policy
resource "akamai_appsec_security_policy" "my_terraform_sec_policy_1" {
  config_id              = akamai_appsec_configuration.my_terraform_appsec_config.id
  default_settings       = true
  security_policy_name   = "Terraformcohortpolicy_1"
  security_policy_prefix = "ter1"
}

resource "akamai_appsec_security_policy" "my_terraform_sec_policy_2" {
  config_id              = akamai_appsec_configuration.my_terraform_appsec_config.id
  default_settings       = true
  security_policy_name   = "Terraformcohortpolicy_2"
  security_policy_prefix = "ter2"
}