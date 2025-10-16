locals {
  notes          = join("-", ["TF-3001", local.my_group_id])
  my_contract_id = replace(var.my_contract, "ctr_", "")
  my_group_id    = replace(var.my_group, "grp_", "")
  #my_contract_id = replace(data.akamai_group.my_group.contract_id, "ctr_", "")
  #my_group_id = replace(data.akamai_group.my_group.id, "grp_", "")
}

#Property
locals {
  rule_format = "v2018-09-12"
}

#DNS
locals {
  dns_zone = "dnslab.webtechnologists.net"
}