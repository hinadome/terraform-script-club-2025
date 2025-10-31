#https://techdocs.akamai.com/terraform/docs/gtm-ds-domain
data "akamai_gtm_domain" "my_gtm_domain" {
  name = "webtechnologists.net.akadns.net"
}

resource "akamai_gtm_domain" "my_gtm_domain" {
  contract                  = var.my_contract
  group                     = var.my_group
  name                      = "webtechnologists.net.akadns.net"
  type                      = "basic"
  email_notification_list   = ["hinadome@akamai.com"]
  load_imbalance_percentage = 10
}