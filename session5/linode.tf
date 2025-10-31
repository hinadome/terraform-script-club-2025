resource "linode_object_storage_key" "terraform_state_key" {
  label = "tfstate-cohort"
}

resource "linode_object_storage_bucket" "terraform_state_bucket" {
  region = "us-lax"
  label  = "tfstate-cohort"

  access_key = linode_object_storage_key.terraform_state_key.access_key
  secret_key = linode_object_storage_key.terraform_state_key.secret_key

}