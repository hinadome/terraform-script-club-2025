#moved {
#  from = akamai_dns_record.my_cname_records
#  to   = akamai_dns_record.my_terraform_cname_records
#}
#https://techdocs.akamai.com/terraform/docs/dns-record
resource "akamai_dns_record" "my_terraform_cname_records" {
  count      = length(local.app_hostnames)
  zone       = local.dns_zone
  recordtype = "CNAME"
  ttl        = 60
  target     = ["terraform.dnslab.webtechnologists.net"]
  name       = local.app_hostnames[count.index]
}

# Excercise for_each
resource "akamai_dns_record" "my_terraform_origin_a_records" {
  for_each   = var.dns_records
  zone       = local.dns_zone
  recordtype = each.value.recordType
  ttl        = each.value.ttl
  target     = [each.value.target]
  name       = each.value.name
}
