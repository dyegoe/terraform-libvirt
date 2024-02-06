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
    public = {
      mode      = "nat"
      domain    = "public.local"
      addresses = ["10.10.20.0/24"]
    }
    private = {
      mode      = "none"
      domain    = "private.local"
      addresses = ["192.168.20.0/24"]
    }

  }
  user                 = "user"
  groups               = ["users", "admin"]
  ssh_public_key       = var.ssh_public_key
  source_volume        = "AlmaLinux-9-GenericCloud-latest.x86_64.qcow2"
  memory               = 4096
  vcpu                 = 2
  autostart            = true
  disk_size            = 20
  additional_disk      = true
  additional_disk_size = 2
  instances = {
    "bastion" = {
      memory = 512
      networks = {
        public  = { ip_address = "10.10.20.10" }
        private = { ip_address = "192.168.20.10" }
      }
      additional_disk = false
      bastion         = true
    }
    "app1" = {
      networks = {
        private = { ip_address = "192.168.20.11" }
      }
      user_data_template = file("${path.module}/cloud-config.yaml")
    }
    "app2" = {
      networks = {
        private = { ip_address = "192.168.20.12" }
      }
      user_data_template = file("${path.module}/cloud-config.yaml")
    }
    "app3" = {
      networks = {
        private = { ip_address = "192.168.20.13" }
      }
      user_data_template = file("${path.module}/cloud-config.yaml")
    }
  }
}
