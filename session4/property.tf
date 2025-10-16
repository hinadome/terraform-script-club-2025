# get property_rules using akamai terraform
# docker run --rm -it --name akamai -v $HOME/.edgerc:/root/.edgerc -v $HOME/code/docker_akamai_cli:/workdir akamai/shell
# akamai --section terraformclub --accountkey 1-6JHGX:1-8BYUX terraform export-property export-property --version 1 "hi_terraform_cohort"
# https://registry.terraform.io/providers/akamai/akamai/1.7.0/docs/data-sources/property_rules_template
data "akamai_property_rules_template" "property_rules" {
  template_file = abspath("${path.module}/property-snippets/main.json")
  variables {
    name  = "origin_hostname"
    value = "origin_linode.dnslab.webtechnologists.net"
    type  = "string"
  }
  variables {
    name  = "sureroute_test_object"
    value = "/testobject.html"
    type  = "string"
  }
  variables {
    name  = "cpcode"
    value = akamai_cp_code.my_cp_code.id
    type  = "number"
  }
  variables {
    name  = "cpcode_name"
    value = akamai_cp_code.my_cp_code.name
    type  = "string"
  }
}

#/https://techdocs.akamai.com/terraform/docs/pm-ds-rules-builder
#https://techdocs.akamai.com/terraform/docs/rule-format-changes
#https://techdocs.akamai.com/terraform/docs/behaviors-criteria
data "akamai_property_rules_builder" "my_default_rule" {
  rules_v2025_04_29 {
    name      = "default"
    is_secure = false
    comments  = <<-EOT
      The behaviors in the default rule apply to all requests for the property hostnames unless another rule overrides these settings.
    EOT
    behavior {
      origin {
        origin_type           = "CUSTOMER"
        hostname              = var.ab_test == "A" ? "A_origin_linode.dnslab.webtechnologists.net" : "B_origin_linode.dnslab.webtechnologists.net"
        forward_host_header   = "REQUEST_HOST_HEADER"
        cache_key_hostname    = "ORIGIN_HOSTNAME"
        compress              = true
        enable_true_client_ip = false
        http_port             = 80
      }
    }
    behavior {
      caching {
        behavior = "NO_STORE"
      }
    }
    behavior {
      cp_code {
        value {
          id   = akamai_cp_code.my_cp_code.id
          name = akamai_cp_code.my_cp_code.name
        }
      }
    }
    children = [
      data.akamai_property_rules_builder.content_cache.json
    ]
  }
}

data "akamai_property_rules_builder" "content_cache" {
  rules_v2025_04_29 {
    name     = "File Extension"
    comments = "Matches the requested filename's extension."
    criterion {
      file_extension {
        values               = ["png", "jpg", "jpeg", "gif"]
        match_case_sensitive = false
        match_operator       = "IS_ONE_OF"
      }
    }
    behavior {
      caching {
        behavior        = "MAX_AGE"
        must_revalidate = false
        ttl             = "60m"
      }
    }
  }
}

#https://techdocs.akamai.com/terraform/docs/pm-rc-cp-code
resource "akamai_cp_code" "my_cp_code" {
  name        = "HI-TerraformCohort"
  group_id    = var.my_group
  contract_id = var.my_contract
  product_id  = "prd_Fresca"
}

#https://techdocs.akamai.com/terraform/docs/pm-rc-property
resource "akamai_property" "my_terraform_property" {
  name        = var.my_property_name
  product_id  = "prd_Fresca"
  contract_id = var.my_contract
  group_id    = var.my_group
  hostnames {
    cname_from = "terraform.dnslab.webtechnologists.net"
    cname_to   = "terraform.dnslab.webtechnologists.net.edgesuite.net"
    #cname_to  = akamai_edge_hostname.my_edge_hostname.edge_hostname
    cert_provisioning_type = "CPS_MANAGED"
  }
  dynamic "hostnames" {
    for_each = local.app_hostnames
    content {
      cname_from             = hostnames.value
      cname_to               = "terraform.dnslab.webtechnologists.net.edgesuite.net"
      cert_provisioning_type = "DEFAULT"
    }
  }
  rules       = data.akamai_property_rules_builder.my_default_rule.json
  rule_format = data.akamai_property_rules_builder.my_default_rule.rule_format
  #rules       = data.akamai_property_rules_template.property_rules.json
  #rule_format = local.rule_format
}

#https://techdocs.akamai.com/terraform/docs/pm-rc-activation
resource "akamai_property_activation" "my_staging_activation" {
  property_id                    = akamai_property.my_terraform_property.id
  network                        = "STAGING"
  contact                        = ["hinadome@akamai.com"]
  note                           = local.notes
  version                        = "1"
  auto_acknowledge_rule_warnings = true
  timeouts {
    default = "1h"
  }
  lifecycle {
    ignore_changes = [
      note
    ]
  }
}

resource "akamai_property_activation" "my_production_activation" {
  property_id                    = akamai_property.my_terraform_property.id
  network                        = "PRODUCTION"
  contact                        = ["hinadome@akamai.com"]
  note                           = local.notes
  version                        = "1"
  auto_acknowledge_rule_warnings = true
  timeouts {
    default = "1h"
  }

  #https://collaborate.akamai.com/confluence/pages/viewpage.action?spaceKey=DEVOPSHARMONY&title=Terraform+for+Akamai+PS
  compliance_record {
    noncompliance_reason_other {
      other_noncompliance_reason = "NO_PRODUCTION_TRAFFIC"
    }
  }
  lifecycle {
    ignore_changes = [
      note
    ]
  }
  depends_on = [akamai_property_activation.my_staging_activation]
}

#https://techdocs.akamai.com/terraform/docs/pm-ds-property-activation
#data "akamai_property_activation" "my_staging_property_activation" {
#  property_id = akamai_property.my_terraform_property.id
#  network     = "STAGING"
#}
#data "akamai_property_activation" "my_production_property_activation" {
#  property_id = akamai_property.my_terraform_property.id
#  network     = "PRODUCTION"
#}

#https://techdocs.akamai.com/terraform/docs/pm-rc-edge-hostname
#
#resource "akamai_edge_hostname" "my_edge_hostname" {
#  product_id    = "prd_Fresca"
#  group_id      = data.akamai_group.my_group.id
#  contract_id   = data.akamai_contract.my_contract.id
#  edge_hostname = "terraform.dnslab.webtechnologists.net.edgesuite.net"
#  ip_behavior   = "IPV4"
#  ttl           = 300
#}
/*
akamai_edge_hostname.my_edge_hostname: Still creating... [07m30s elapsed]
akamai_edge_hostname.my_edge_hostname: Still creating... [07m40s elapsed]
akamai_edge_hostname.my_edge_hostname: Still creating... [07m50s elapsed]
akamai_edge_hostname.my_edge_hostname: Still creating... [08m00s elapsed]
╷
│ Error: update edge hostname: API error: 
│ {
│       "type": "/hapi/problems/permission-denied-on-cname",
│       "title": "Permission Denied on CNAME",
│       "detail": "Permission denied on cname: scope and id combination not found",
│       "instance": "/hapi/error-instances/7c695862-c0e0-4a70-b114-d60f7f81ead2",
│       "requestInstance": "http://origin.pulsar.akamai.com/hapi/open/v1/dns-zones/edgesuite.net/edge-hostnames/terraform.dnslab.webtechnologists.net?accountSwitchKey=1-6JHGX%3A1-8BYUX\u0026comments=change+%2Fttl+to+300#5e6069cf",
│       "method": "PATCH",
│       "requestTime": "2025-10-02T06:23:03.230196389Z",
│       "status": 403
│ }
│ 
│   with akamai_edge_hostname.my_edge_hostname,
│   on property.tf line 10, in resource "akamai_edge_hostname" "my_edge_hostname":
│   10: resource "akamai_edge_hostname" "my_edge_hostname" {
*/