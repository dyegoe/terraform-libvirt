terraform {
  required_version = ">= 1.3"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.1"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

module "example" {
  source            = "../."
  user              = "ubuntu"
  groups            = ["users", "admin"]
  ssh_public_key    = var.ssh_public_key
  source_disk_image = "/var/lib/libvirt/images/jammy-server-cloudimg-amd64.img"
  network = {
    name      = "k8s"
    mode      = "nat"
    domain    = "k8s.local"
    addresses = ["10.100.200.0/24"]
  }
  instances = {
    "master" = {
      memory     = 2048
      vcpu       = 2
      autostart  = true
      disk_size  = 8
      ip_address = "10.100.200.2"
    }
    "node01" = {
      memory     = 2048
      vcpu       = 2
      autostart  = true
      disk_size  = 8
      ip_address = "10.100.200.3"
    }
    "node02" = {
      memory     = 2048
      vcpu       = 2
      autostart  = true
      disk_size  = 8
      ip_address = "10.100.200.4"
    }
  }
}

output "ip_address" {
  value = module.example.ip_address
}

output "ssh_command" {
  value = module.example.ssh_command
}
