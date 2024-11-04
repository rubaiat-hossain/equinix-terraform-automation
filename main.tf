# Create a VLAN in Silicon Valley (for node1)
resource "equinix_metal_vlan" "vlan1" {
  description = "VLAN for node1 in Silicon Valley"
  metro       = "sv"
  project_id  = var.project_id
}

# Create a VLAN in New York (for node2)
resource "equinix_metal_vlan" "vlan2" {
  description = "VLAN for node2 in New York"
  metro       = "ny"
  project_id  = var.project_id
}

# Deploy node1 in Silicon Valley
resource "equinix_metal_device" "node1" {
  hostname         = "node1"
  project_id       = var.project_id
  plan             = "c3.small.x86"
  metro            = "sv"
  operating_system = "ubuntu_20_04"
}

# Deploy node2 in New York
resource "equinix_metal_device" "node2" {
  hostname         = "node2"
  project_id       = var.project_id
  plan             = "c3.small.x86"
  metro            = "ny"
  operating_system = "ubuntu_20_04"
}

# Set Hybrid network type for Layer 3 public IP, avoid bonding/unbonding configuration
resource "equinix_metal_device_network_type" "node1_network" {
  device_id = equinix_metal_device.node1.id
  type      = "hybrid"
}

resource "equinix_metal_device_network_type" "node2_network" {
  device_id = equinix_metal_device.node2.id
  type      = "hybrid"
}

# Attach VLANs to `eth1` without setting the bonding flag directly
resource "equinix_metal_port_vlan_attachment" "vlan_attachment_sv" {
  device_id = equinix_metal_device.node1.id
  port_name = "eth1"
  vlan_vnid = equinix_metal_vlan.vlan1.vxlan
  depends_on = [equinix_metal_device_network_type.node1_network]
}

resource "equinix_metal_port_vlan_attachment" "vlan_attachment_ny" {
  device_id = equinix_metal_device.node2.id
  port_name = "eth1"
  vlan_vnid = equinix_metal_vlan.vlan2.vxlan
  depends_on = [equinix_metal_device_network_type.node2_network]
}

# Outputs for public and private IP verification
output "node1_public_ip" {
  value       = equinix_metal_device.node1.access_public_ipv4
  description = "Public IP of node1 in Silicon Valley"
}

output "node2_public_ip" {
  value       = equinix_metal_device.node2.access_public_ipv4
  description = "Public IP of node2 in New York"
}

output "node1_private_ip" {
  value       = equinix_metal_device.node1.access_private_ipv4
  description = "Private IP of node1 in Silicon Valley"
}

output "node2_private_ip" {
  value       = equinix_metal_device.node2.access_private_ipv4
  description = "Private IP of node2 in New York"
}

output "vlan1_id" {
  value       = equinix_metal_vlan.vlan1.id
  description = "VLAN ID for node1 in Silicon Valley"
}

output "vlan2_id" {
  value       = equinix_metal_vlan.vlan2.id
  description = "VLAN ID for node2 in New York"
}
