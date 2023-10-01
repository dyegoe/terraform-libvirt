terraform {
  required_version = ">= 1.4"

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
  source = "../."

  user           = "ubuntu"
  groups         = ["users", "admin"]
  ssh_public_key = var.ssh_public_key

  source_disk_image = "/var/lib/libvirt/images/jammy-server-cloudimg-amd64.img"
  instances = {
    "example1" = {
      memory    = 512
      vcpu      = 1
      autostart = true
      disk_size = 5
    }
    "example2" = {
      memory    = 512
      vcpu      = 1
      autostart = true
      disk_size = 5
    }
  }
}

output "ip_address" {
  value = module.example.ip_address
}

output "ssh_command" {
  value = module.example.ssh_command
}
