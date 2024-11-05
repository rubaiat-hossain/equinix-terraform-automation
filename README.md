# Equinix Metal Network Automation using Terraform

This Terraform IaC configuration deploys two nodes in different Metros and connects them via Equinix Metal's private IP addressiong. The nodes communicate privately over VLANs, with public IP accessibility for management and SSH. The architecture uses Equinix Metal's [Hybrid Bonded Network](https://deploy.equinix.com/developers/docs/metal/layer2-networking/hybrid-bonded-mode/) mode to support both Layer 2 and Layer 3 networking on a single bonded interface (**bond0**).
