resource "equinix_metal_device" "node1" {
  hostname         = "node1"
  project_id       = var.project_id
  plan             = "c3.small.x86"      
  metro            = "sv"                # Silicon Valley location
  operating_system = "ubuntu_20_04"     
}

resource "equinix_metal_device" "node2" {
  hostname         = "node2"
  project_id       = var.project_id
  plan             = "c3.small.x86"
  metro            = "ny"                # New York location
  operating_system = "ubuntu_20_04"
}