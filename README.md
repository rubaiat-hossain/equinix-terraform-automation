# Equinix Metal Network Automation using Terraform

This Terraform IaC configuration deploys two nodes in different Metros and connects them via Equinix Metal's private IP addressing. The nodes communicate privately over VLANs, with public IPs available for management through SSH. The architecture uses Equinix Metal's [Hybrid Bonded Network](https://deploy.equinix.com/developers/docs/metal/layer2-networking/hybrid-bonded-mode/) mode to support both Layer 2 and Layer 3 networking on a single bonded interface (**bond0**).

### To Follow Along:

* Replace the **project_id** in `terraform.tfvars` with your own `project_id`.
* Save your Metal API Token in the environment variable `METAL_AUTH_TOKEN`.

````bash
terraform plan
terraform apply
``
