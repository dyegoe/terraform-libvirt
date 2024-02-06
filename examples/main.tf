terraform {
  required_version = ">= 1.3"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = ">=0.7.1"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

module "example" {
  source = "../."
  networks = {
    k8s = {
      mode      = "nat"
      domain    = "k8s.local"
      addresses = ["10.10.20.0/24"]
    }
  }
  user           = "user"
  groups         = ["users", "admin"]
  ssh_public_key = var.ssh_public_key
  source_volume  = "jammy-server-cloudimg-amd64.img"
  # source_volume  = "AlmaLinux-9-GenericCloud-latest.x86_64.qcow2"
  # source_volume  = "Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"
  # source_volume  = "Fedora-Cloud-Base-39-1.5.x86_64.qcow2"
  memory               = 4096
  vcpu                 = 2
  autostart            = true
  disk_size            = 20
  additional_disk      = true
  additional_disk_size = 2
  instances = {
    "master" = {
      memory          = 2048
      networks        = { k8s = { ip_address = "10.10.20.10" } }
      additional_disk = false
    }
    # "node1" = {
    #   networks = { k8s = { ip_address = "10.10.20.11" } }
    # }
    # "node2" = {
    #   networks = { k8s = { ip_address = "10.10.20.12" } }
    # }
    # "node3" = {
    #   networks = { k8s = { ip_address = "10.10.20.13" } }
    # }
  }
}
