# Setup
- Install PowerShell
  ```
  brew update
  brew install --cask powershell
  pwsh
  PowerShell 7.5.4
  ```
- Clone Repository 
  ```
  git clone ps-terraform-templates
  session9 % ls
  README.md		ps-terraform-templates
  ```
- Explore template
  - new-aap-configuration( creation )
    - adjust tfvars
      ```
      cp ./environments/prod/prod.tfvars.dist ./environments/prod/prod.tfvars 
      Modify tfvars
      ```
    - execute script
      ```
      pwsh deploy.ps1 aap -Env prod -Save -Notes "Test for app configuration" -Dry

      Saved the plan to: ./environments/prod/prod-save.tfplan

      To perform exactly these actions, run the following command to apply:
      terraform apply "./environments/prod/prod-save.tfplan"
      Terraform execution completed successfully.
      
      pwsh deploy.ps1 aap -Env prod -Save -Notes "Test for app configuration"
      │ Error: Title: Forbidden; Type: https://problems.luna.akamaiapis.net/-/pep-authz/deny; Detail: The client does not have the grant needed for the request
      │ 
      with module.client-lists[0].akamai_clientlist_list.client-lists-ipblock,
      │   on .terraform/modules/client-lists/aap/client-lists/main.tf line 12, in resource "akamai_clientlist_list" "client-lists-ipblock":
      │   12: resource "akamai_clientlist_list" "client-lists-ipblock" {
      │ 
      ╵
      ╷
      │ Error: Title: Forbidden; Type: https://problems.luna.akamaiapis.net/-/pep-authz/deny; Detail: The client does not have the grant needed for the request
      │ 
      │   with module.client-lists[0].akamai_clientlist_list.client-lists-ipblock-list-exceptions,
      │   on .terraform/modules/client-lists/aap/client-lists/main.tf line 21, in resource "akamai_clientlist_list" "client-lists-ipblock-list-exceptions":
      │   21: resource "akamai_clientlist_list" "client-lists-ipblock-list-exceptions" {
      WARNING: Terraform apply failed with exit code: 1
      Write-Error: Failed to run terraform apply after 2 attempts.
      Exception: /Users/hinadome/code/terraform-script-club-2025/session9/ps-terraform-templates/deploy.ps1:278:21
      Line |
      278 |  …             throw "Maximum retry attempts reached for terraform execu …
      |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      | Maximum retry attempts reached for terraform execution.
      ```
    - Fix Permission
      ```
      adding Client List Permission on ACC
      wsh deploy.ps1 aap -Env prod -Save -Notes "Test for app configuration"
      │ Error: Missing required argument
      
      │   with module.security.akamai_appsec_ip_geo.tfdemo,
      │   on .terraform/modules/security/aap/security/firewall.tf line 4, in resource "akamai_appsec_ip_geo" "tfdemo":
      │    4:   security_policy_id         = data.akamai_appsec_security_policy.policy.security_policy_id
      │ 
      │ The argument "security_policy_id" is required, but no definition was found.
      ╵
      ╷
      │ Error: Missing required argument
      │ 
      │   with module.security.akamai_appsec_bypass_network_lists.bypass,
      │   on .terraform/modules/security/aap/security/main.tf line 37, in resource "akamai_appsec_bypass_network_lists" "bypass":
      │   37:   security_policy_id  = data.akamai_appsec_security_policy.policy.security_policy_id
      │ 
      │ The argument "security_policy_id" is required, but no definition was found.
      ╵
      ╷
      │ Error: Missing required argument
      │ 
      │   with module.security.akamai_appsec_penalty_box.tfdemo,
      │   on .terraform/modules/security/aap/security/penalty-box.tf line 4, in resource "akamai_appsec_penalty_box" "tfdemo":
      │    4:   security_policy_id     = data.akamai_appsec_security_policy.policy.security_policy_id
      │ 
      │ The argument "security_policy_id" is required, but no definition was found.
      ╵
      ╷
      │ Error: Missing required argument
      │ 
      │   with module.security.akamai_appsec_waf_protection.tfdemo,
      │   on .terraform/modules/security/aap/security/protections.tf line 4, in resource "akamai_appsec_waf_protection" "tfdemo":
      │    4:   security_policy_id = data.akamai_appsec_security_policy.policy.security_policy_id
      │ 
      .......
      Line |
      278 |  …             throw "Maximum retry attempts reached for terraform execu …
      |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      | Maximum retry attempts reached for terraform execution.
      manually added
      ```
    - Fix Manually added required resource since module security reference data but security policy is not defined as resource so no security policy exists
      ```
      main.tf under security module
      data "akamai_appsec_security_policy" "policy" {
          config_id            = akamai_appsec_configuration.config.config_id
          security_policy_name = "First Security Policy"
      }
      No creation process on module(security policy not exists), other tf files can not reference data.akamai_appsec_security_policy.policy.security_policy_id  and getting error
      ```
      ```
      To perform exactly these actions, run the following command to apply:
      terraform apply "./environments/prod/prod-save.tfplan"
      module.security.akamai_appsec_advanced_settings_pragma_header.pragma_header: Modifying... [id=120962]
      module.security.akamai_appsec_bypass_network_lists.bypass: Creating...
      module.security.akamai_appsec_advanced_settings_pragma_header.pragma_header: Modifications complete after 7s [id=120962]
      ╷
      │ Error: Title: Invalid Input Error; Type: https://problems.luna.akamaiapis.net/appsec/error-types/INVALID-INPUT-ERROR; Detail: Feature not available in this product
      │ 
      │   with module.security.akamai_appsec_bypass_network_lists.bypass,
      │   on .terraform/modules/security/aap/security/main.tf line 35, in resource "akamai_appsec_bypass_network_lists" "bypass":
      │   35: resource "akamai_appsec_bypass_network_lists" "bypass" {
      │ 
      ╵
      WARNING: Terraform apply failed with exit code: 1
      Write-Error: Failed to run terraform apply after 2 attempts.
      Exception: /Users/hinadome/code/terraform-script-club-2025/session9/ps-terraform-templates/deploy.ps1:278:21
      Line |
      278 |  …             throw "Maximum retry attempts reached for terraform execu …
      |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      | Maximum retry attempts reached for terraform execution.
      ```
    - Other error observed
      ```
      ╷
      │ Error: Resource already managed by Terraform
      │ 
      │ Terraform is already managing a remote object for module.security.akamai_appsec_rate_policy.origin_error. To import to this address you must first remove the existing object
      │ from the state.
      ╷
      |Error: Resource already managed by Terraform
      │ 
      │ Terraform is already managing a remote object for module.security.akamai_appsec_rate_policy.post_page_requests. To import to this address you must first remove the existing
      │ object from the state.
      │ Error: Resource already managed by Terraform
      │ 
      │ Terraform is already managing a remote object for module.security.akamai_appsec_rate_policy.page_view_requests. To import to this address you must first remove the existing
      │ object from the state.
      ╵
      ```
  - new-aap-configuration( staging push )
    ```
    pwsh deploy.ps1 aap -Env prod -ActivateStaging
    Please enter version/activation notes: Test Staging Push
    
    ╷
    | Error: Title: Invalid Input Error; Type: https://problems.luna.akamaiapis.net/appsec/error-types/INVALID-INPUT-ERROR; Detail: Feature not available in this product
    │ 
    │   with module.security.akamai_appsec_bypass_network_lists.bypass,
    │   on .terraform/modules/security/aap/security/main.tf line 35, in resource "akamai_appsec_bypass_network_lists" "bypass":
    │   35: resource "akamai_appsec_bypass_network_lists" "bypass" {
    │ 
    ╵
    WARNING: Terraform apply failed with exit code: 1
    Write-Error: Failed to run terraform apply after 2 attempts.
    Exception: /Users/hinadome/code/terraform-script-club-2025/session9/ps-terraform-templates/deploy.ps1:278:21
    Line |
    278 |  …             throw "Maximum retry attempts reached for terraform execu …
    |                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    | Maximum retry attempts reached for terraform execution.
    ```
  - new-aapasm-configuration( creation )
    - adjust tfvars
      ```
      cp ./environments/prod/prod.tfvars.dist ./environments/prod/prod.tfvars 
      Modify tfvars
      ```
    - execute script
      ```
      pwsh deploy.ps1 aapasm -Env prod -Save -Notes "Test for app configuration with aapasm"
      Apply complete! Resources: 32 added, 2 changed, 0 destroyed.
      
      Outputs:
      
      config_id = 120968
      security_policy_id = "TF01_316822"
      Terraform execution completed successfully.
      
      ================================
      Script Execution Summary
      ================================
      Started:  2025-11-21 19:44:02
      Finished: 2025-11-21 19:45:50
      Total Duration (hh:mm:ss): 00:01:48
      ================================
      ```
  - new-aap-configuration( staging push )
    ```
    pwsh deploy.ps1 aapasm -Env prod -ActivateStaging                                     
    Please enter version/activation notes: Test Staging Push
    You entered the following version/activation notes: Test Staging Push
    Apply complete! Resources: 1 added, 3 changed, 0 destroyed.
    
    Outputs:
    
    config_id = 120968
    security_policy_id = "TF01_316822"
    Terraform execution completed successfully.
    
    ================================
    Script Execution Summary
    ================================
    Started:  2025-11-21 19:52:13
    Finished: 2025-11-21 19:55:15
    Total Duration (hh:mm:ss): 00:03:02
    ================================
    ```