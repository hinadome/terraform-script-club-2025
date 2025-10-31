#https://techdocs.akamai.com/terraform/docs/gtm-ds-domain
data "akamai_gtm_domain" "my_gtm_domain" {
  name = "webtechnologists.net.akadns.net"
}

data "akamai_gtm_datacenters" "my_datacenters" {
  domain = data.akamai_gtm_domain.my_gtm_domain.name
}

data "akamai_gtm_datacenter" "my_datacenter_1" {
  domain        = data.akamai_gtm_domain.my_gtm_domain.name
  datacenter_id = 1
}

data "akamai_gtm_datacenter" "my_datacenter_2" {
  domain        = data.akamai_gtm_domain.my_gtm_domain.name
  datacenter_id = 5400
}

resource "akamai_gtm_domain" "my_gtm_domain" {
  contract                  = var.my_contract
  group                     = var.my_group
  name                      = "webtechnologists.net.akadns.net"
  type                      = "basic"
  email_notification_list   = ["hinadome@akamai.com"]
  load_imbalance_percentage = 10
}

resource "akamai_gtm_datacenter" "my_datecenter1" {
  domain   = data.akamai_gtm_domain.my_gtm_domain.name
  nickname = "Test_DC_of_webtechnologists.net"
}

resource "akamai_gtm_datacenter" "my_datecenter2" {
  domain   = data.akamai_gtm_domain.my_gtm_domain.name
  nickname = "Default Datacenter"
}