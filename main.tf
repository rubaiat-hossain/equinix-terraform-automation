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

# Create a Metal Gateway for VLAN in Silicon Valley
resource "equinix_metal_gateway" "gateway_sv" {
  project_id               = var.project_id
  vlan_id                  = equinix_metal_vlan.vlan1.id
  private_ipv4_subnet_size = 16   # Adjust subnet size as needed
}

# Create a Metal Gateway for VLAN in New York
resource "equinix_metal_gateway" "gateway_ny" {
  project_id               = var.project_id
  vlan_id                  = equinix_metal_vlan.vlan2.id
  private_ipv4_subnet_size = 16   # Adjust subnet size as needed
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

# Set Silicon Valley device's bond0 port to Layer 2 mode
resource "equinix_metal_port" "bond0_sv" {
  port_id = element([for p in equinix_metal_device.node1.ports: p.id if p.name == "bond0"], 0)
  bonded  = true
  layer2  = true
}

# Set New York device's bond0 port to Layer 2 mode
resource "equinix_metal_port" "bond0_ny" {
  port_id = element([for p in equinix_metal_device.node2.ports: p.id if p.name == "bond0"], 0)
  bonded  = true
  layer2  = true
}

# Attach Silicon Valley device's bond0 to VLAN
resource "equinix_metal_port_vlan_attachment" "vlan_attachment_sv" {
  device_id = equinix_metal_device.node1.id
  port_name = "bond0"
  vlan_vnid = equinix_metal_vlan.vlan1.vxlan
  depends_on = [equinix_metal_port.bond0_sv]
}

# Attach New York device's bond0 to VLAN
resource "equinix_metal_port_vlan_attachment" "vlan_attachment_ny" {
  device_id = equinix_metal_device.node2.id
  port_name = "bond0"
  vlan_vnid = equinix_metal_vlan.vlan2.vxlan
  depends_on = [equinix_metal_port.bond0_ny]
}

# Outputs for verification
output "vlan1_id" {
  value       = equinix_metal_vlan.vlan1.id
  description = "VLAN ID for node1 in Silicon Valley"
}

output "vlan2_id" {
  value       = equinix_metal_vlan.vlan2.id
  description = "VLAN ID for node2 in New York"
}

output "node1_private_ip" {
  value       = equinix_metal_device.node1.access_private_ipv4
  description = "Private IP of node1 in Silicon Valley"
}

output "node2_private_ip" {
  value       = equinix_metal_device.node2.access_private_ipv4
  description = "Private IP of node2 in New York"
}

output "gateway_sv_ip" {
  value       = equinix_metal_gateway.gateway_sv.private_ipv4_subnet_size
  description = "IP range for Metal Gateway in Silicon Valley"
}

output "gateway_ny_ip" {
  value       = equinix_metal_gateway.gateway_ny.private_ipv4_subnet_size
  description = "IP range for Metal Gateway in New York"
}
