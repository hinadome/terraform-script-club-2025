output "my_state_bucket" {
  value = linode_object_storage_bucket.terraform_state_bucket.label
}

output "my_gtm_domain" {
  value = akamai_gtm_domain.my_gtm_domain
}

output "my_datacenters" {
  value = data.akamai_gtm_datacenters.my_datacenters
}

output "my_datacenter_1" {
  value = data.akamai_gtm_datacenter.my_datacenter_1
}

output "my_datacenter_2" {
  value = data.akamai_gtm_datacenter.my_datacenter_2
}