# Create VLANs in different metros with distinct IDs
resource "equinix_metal_vlan" "vlan1" {
  description = "VLAN for node1 in Silicon Valley"
  metro       = "sv"
  project_id  = var.project_id
  vxlan       = 1000
}

resource "equinix_metal_vlan" "vlan2" {
  description = "VLAN for node2 in New York"
  metro       = "ny"
  project_id  = var.project_id
  vxlan       = 1001
}

# Deploy Node1 in Silicon Valley with Hybrid Bonded mode
resource "equinix_metal_device" "node1" {
  hostname         = "node1"
  project_id       = var.project_id
  plan             = "c3.small.x86"
  metro            = "sv"
  operating_system = "ubuntu_20_04"
  billing_cycle    = "hourly"
}

# Deploy Node2 in New York with Hybrid Bonded mode
resource "equinix_metal_device" "node2" {
  hostname         = "node2"
  project_id       = var.project_id
  plan             = "c3.small.x86"
  metro            = "ny"
  operating_system = "ubuntu_20_04"
  billing_cycle    = "hourly"
}

# Configure Metal Gateway for each VLAN
resource "equinix_metal_gateway" "gw_vlan1" {
  project_id               = var.project_id
  vlan_id                  = equinix_metal_vlan.vlan1.id
  private_ipv4_subnet_size = 8
}

resource "equinix_metal_gateway" "gw_vlan2" {
  project_id               = var.project_id
  vlan_id                  = equinix_metal_vlan.vlan2.id
  private_ipv4_subnet_size = 8
}

# Set Hybrid Bonded mode and VLAN assignment for Node1 (Silicon Valley)
resource "equinix_metal_device_network_type" "node1_hybrid" {
  device_id = equinix_metal_device.node1.id
  type      = "hybrid"
}

resource "equinix_metal_port_vlan_attachment" "vlan_attachment_node1" {
  device_id   = equinix_metal_device.node1.id
  port_name   = "bond0"
  vlan_vnid   = equinix_metal_vlan.vlan1.vxlan
  native      = false
}

# Set Hybrid Bonded mode and VLAN assignment for Node2 (New York)
resource "equinix_metal_device_network_type" "node2_hybrid" {
  device_id = equinix_metal_device.node2.id
  type      = "hybrid"
}

resource "equinix_metal_port_vlan_attachment" "vlan_attachment_node2" {
  device_id   = equinix_metal_device.node2.id
  port_name   = "bond0"
  vlan_vnid   = equinix_metal_vlan.vlan2.vxlan
  native      = false
}

# Outputs for verification
output "node1_private_ip" {
  value       = equinix_metal_device.node1.access_private_ipv4
  description = "Private IP of node1 in Silicon Valley"
}

output "node2_private_ip" {
  value       = equinix_metal_device.node2.access_private_ipv4
  description = "Private IP of node2 in New York"
}

output "node1_public_ip" {
  value       = equinix_metal_device.node1.access_public_ipv4
  description = "Public IP of node1 in Silicon Valley"
}

output "node2_public_ip" {
  value       = equinix_metal_device.node2.access_public_ipv4
  description = "Public IP of node2 in New York"
}

output "vlan1_id" {
  value       = equinix_metal_vlan.vlan1.id
  description = "VLAN ID for node1 in Silicon Valley"
}

output "vlan2_id" {
  value       = equinix_metal_vlan.vlan2.id
  description = "VLAN ID for node2 in New York"
}
