terraform {
  required_version = ">= 1.3"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = ">=0.7.1"
    }
    template = {
      source  = "hashicorp/template"
      version = ">=2.2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.5.1"
    }
    htpasswd = {
      source  = "loafoe/htpasswd"
      version = ">=1.0.4"
    }
  }
}
