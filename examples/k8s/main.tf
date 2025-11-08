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
  source = "../../."
  networks = {
    k8s = {
      mode      = "nat"
      domain    = "k8s.local"
      addresses = ["10.10.20.0/24"]
    }
  }
  user                 = "user"
  groups               = ["wheel"]
  ssh_public_key       = var.ssh_public_key
  source_volume        = "Rocky-10-GenericCloud-Base.latest.x86_64.qcow2"
  memory               = 4096
  vcpu                 = 2
  autostart            = true
  disk_size            = 20
  additional_disk      = true
  additional_disk_size = 5
  instances = {
    "master" = {
      # groups         = ["users", "admin"]
      # source_volume   = "noble-server-cloudimg-amd64.img"
      memory          = 2048
      networks        = { k8s = { ip_address = "10.10.20.10" } }
      additional_disk = false
    }
    "node1" = {
      networks = { k8s = { ip_address = "10.10.20.11" } }
    }
    "node2" = {
      networks = { k8s = { ip_address = "10.10.20.12" } }
    }
    "node3" = {
      source_volume = "noble-server-cloudimg-amd64.img"
      networks      = { k8s = { ip_address = "10.10.20.13" } }
    }
  }
}
