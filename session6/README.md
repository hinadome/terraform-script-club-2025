# Akamai CLI
- Docker
  ```
  docker run -it -v $HOME/.edgerc:/root/.edgerc:ro -v $HOME/code/terraform-script-club-2025/session5:/workdir:rw akamai/shell
  ```
- Terraform
  ```
  Downlod and use (Docker terraform is outdated)
  https://developer.hashicorp.com/terraform/install
  Akamai DevOps [/workdir] >> ./terraform version
  Terraform v1.13.4
  on linux_amd64
  provider registry.terraform.io/akamai/akamai v9.1.0
  ```

# Linode Backend 
- Backend
  - Error
    ```
    "s3" backend:
    │ failed to upload state: operation error S3: PutObject, https response error StatusCode: 400, RequestID: tx00000c97b58bddc144014-006904c3d8-11960b18d-default, HostID: 11960b18d-default-default, api error XAmzContentSHA256Mismatch: UnknownError
    
    export AWS_RESPONSE_CHECKSUM_VALIDATION=off
    export AWS_EC2_METADATA_DISABLED=true
    
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true  -> added
    se_path_style              = true   -> added
    skip_metadata_api_check     = true
    ```
  - using backend as config
  - terraform init -backend-config=backend -reconfigure 

# GTM Import 
- GTM Domain
  - import process
    ```
    terraform import akamai_gtm_domain.my_gtm_domain webtechnologists.net.akadns.net 
    resource "akamai_gtm_domain" "my_gtm_domain" {} on gtm.tf 
    ```
  - modify resource
  - terraform plan
  terraform plan
    ```
    # akamai_gtm_domain.my_gtm_domain will be updated in-place
    ~ resource "akamai_gtm_domain" "my_gtm_domain" {
      ~ comment                         = "only ns" -> "Managed by Terraform"
        id                              = "webtechnologists.net.akadns.net"
        name                            = "webtechnologists.net.akadns.net"
        # (31 unchanged attributes hidden)
    }
    ```
  - Error on terraform apply
    ```
    akamai_gtm_domain.my_gtm_domain: Modifying... [id=webtechnologists.net.akadns.net]
    ╷
    │ Error: Domain update error
    │ 
    │   with akamai_gtm_domain.my_gtm_domain,
    │   on gtm.tf line 6, in resource "akamai_gtm_domain" "my_gtm_domain":
    │    6: resource "akamai_gtm_domain" "my_gtm_domain" {
    │ 
    │ contract not present in resource data: value not found: contract
    ```
  - Adding contract and group
  - Terraform appy
    ```
    Domain Change History for webtechnologists.net.akadns.net
    Oct 31, 2025 04:20 PM +00:00	
    Managed by Terraform
    Changes for domain webtechnologists.net.akadns.net:
    modificationComments changed to: "Managed by Terraform"
    ```
- Datacenter
  - Import Datacenter1
    ```
    terraform import akamai_gtm_datacenter.my_datecenter1 "webtechnologists.net.akadns.net:1"  

    resource "akamai_gtm_datacenter" "my_datecenter1" {
    # (resource arguments)
    }
    ```
  - Modify resource
    ```
    resource "akamai_gtm_datacenter" "my_datecenter1" {
      domain = data.akamai_gtm_domain.my_gtm_domain.name 
      nickname = "Test_DC_of_webtechnologists.net"
    }
    ```
  - terraform apply
  - Import Datacenter2
    ```
    terraform import akamai_gtm_datacenter.my_datecenter2 "webtechnologists.net.akadns.net:5400"  

    resource "akamai_gtm_datacenter" "my_datecenter2" {
    # (resource arguments)
    }
    ```
  - Modify resource
    ```
    resource "akamai_gtm_datacenter" "my_datecenter1" {
      domain = data.akamai_gtm_domain.my_gtm_domain.name 
      nickname = "Test_DC_of_webtechnologists.net"
    }
    ```
  - terraform apply
