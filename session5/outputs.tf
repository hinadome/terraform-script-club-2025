output "my_state_bucket" {
  value = linode_object_storage_bucket.terraform_state_bucket.label
}

output "my_gtm_domain" {
  value = akamai_gtm_domain.my_gtm_domain
}