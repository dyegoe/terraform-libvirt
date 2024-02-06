# Terraform LibVirt Module

This module creates a LibVirt domain (instances) using Terraform.

- [Terraform LibVirt Module](#terraform-libvirt-module)
  - [Pre-requisites](#pre-requisites)
  - [Usage](#usage)
  - [Examples](#examples)
  - [Requirements](#requirements)
  - [Providers](#providers)
  - [Modules](#modules)
  - [Resources](#resources)
  - [Inputs](#inputs)
  - [Outputs](#outputs)
  - [Dependencies](#dependencies)
  - [Authors](#authors)
  - [License](#license)

## Pre-requisites

This module requires an already installed and configured LibVirt environment.

It is also expected that you already have a base image to use for the instances.

Ubuntu 22.04 LTS (Jammy) cloud images can be downloaded from [here](https://cloud-images.ubuntu.com/jammy/current/).

```bash
sudo rm -rf /var/lib/libvirt/images/jammy-server-cloudimg-amd64.img
sudo curl -o /var/lib/libvirt/images/jammy-server-cloudimg-amd64.img -fSL https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
virsh pool-refresh default
```

AlmaLinux 9 cloud images can be downloaded from [here](https://almalinux.org/get-almalinux/#Cloud_Images).

```bash
sudo rm -rf /var/lib/libvirt/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2
sudo curl -o /var/lib/libvirt/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2 -fsSL https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2
virsh pool-refresh default
```

Rocky Linux 9 cloud images can be downloaded from [here](https://rockylinux.org/alternative-images).

```bash
sudo rm -rf /var/lib/libvirt/images/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2
sudo curl -o /var/lib/libvirt/images/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2 -fsSL https://dl.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2
virsh pool-refresh default
```

Fedora 39 cloud images can be downloaded from [here](https://fedoraproject.org/cloud/download).

```bash
sudo rm -rf /var/lib/libvirt/images/Fedora-Cloud-Base-39-1.5.x86_64.qcow2
sudo curl -o /var/lib/libvirt/images/Fedora-Cloud-Base-39-1.5.x86_64.qcow2 -fsSL https://download.fedoraproject.org/pub/fedora/linux/releases/39/Cloud/x86_64/images/Fedora-Cloud-Base-39-1.5.x86_64.qcow2
virsh pool-refresh default
```

## Usage

```hcl
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
  source = "github.com/dyegoe/terraform-libvirt?ref=main"
  network = {
    name      = "example"
    mode      = "nat"
    domain    = "example.local"
    addresses = ["192.168.200.0/24"]
  }
  user           = "user"
  groups         = ["users", "admin"]
  ssh_public_key = "ssh-ed25519 AAAA..."
  source_volume  = "jammy-server-cloudimg-amd64.img"
  memory         = 512
  vcpu           = 1
  autostart      = true
  disk_size      = 3
  instances = {
    "example1" = {
      # when the values are not specified, the default values provided above are used.
      ip_address = "192.168.200.2"
    }
    "example2" = {
      user           = "example2"
      groups         = ["users"]
      ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMK/KqEF4iwVKvNyYTIymM+oXYsW493/wE7RnKtEYhNF"
      source_volume  = "mantic-server-cloudimg-amd64.img"
      memory         = 1024
      vcpu           = 2
      autostart      = false
      disk_size      = 4
      # when the ip_address is not specified, the instance will not have a static IP address. It will be assigned by DHCP.
    }
  }
}

output "ip_address" {
  value = module.example.ip_address
}

output "ssh_command" {
  value = module.example.ssh_command
}

output "root_password" {
  value     = module.example.root_password
  sensitive = true
}
```

## Examples

You can find an example [here](examples/) of how to use this module.

<!-- markdownlint-disable MD033 -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_htpasswd"></a> [htpasswd](#requirement\_htpasswd) | >=1.0.4 |
| <a name="requirement_libvirt"></a> [libvirt](#requirement\_libvirt) | >=0.7.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >=3.5.1 |
| <a name="requirement_template"></a> [template](#requirement\_template) | >=2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_htpasswd"></a> [htpasswd](#provider\_htpasswd) | >=1.0.4 |
| <a name="provider_libvirt"></a> [libvirt](#provider\_libvirt) | >=0.7.1 |
| <a name="provider_random"></a> [random](#provider\_random) | >=3.5.1 |
| <a name="provider_template"></a> [template](#provider\_template) | >=2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [htpasswd_password.this](https://registry.terraform.io/providers/loafoe/htpasswd/latest/docs/resources/password) | resource |
| [libvirt_cloudinit_disk.this](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/cloudinit_disk) | resource |
| [libvirt_domain.name](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/domain) | resource |
| [libvirt_network.this](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/network) | resource |
| [libvirt_volume.additional](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/volume) | resource |
| [libvirt_volume.this](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs/resources/volume) | resource |
| [random_password.salt](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_password.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [template_file.user_data](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_disk"></a> [additional\_disk](#input\_additional\_disk) | Whether to create an additional disk for each instance. | `bool` | `false` | no |
| <a name="input_additional_disk_size"></a> [additional\_disk\_size](#input\_additional\_disk\_size) | The size of the additional disk to create for each instance in GB. | `number` | `1` | no |
| <a name="input_autostart"></a> [autostart](#input\_autostart) | Whether to automatically start the instances when the host boots. | `bool` | `true` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | The size of the disk to create for each instance in GB. | `number` | `3` | no |
| <a name="input_groups"></a> [groups](#input\_groups) | The groups to add the user to. | `list(string)` | <pre>[<br>  "users",<br>  "admin"<br>]</pre> | no |
| <a name="input_instances"></a> [instances](#input\_instances) | A map of instance names to instance configurations. disk\_size is in GB. | <pre>map(object({<br>    user                 = optional(string)<br>    groups               = optional(list(string))<br>    ssh_public_key       = optional(string)<br>    source_volume        = optional(string)<br>    memory               = optional(number)<br>    vcpu                 = optional(number)<br>    autostart            = optional(bool)<br>    disk_size            = optional(number)<br>    additional_disk      = optional(bool)<br>    additional_disk_size = optional(number)<br>    bastion              = optional(bool, false)<br>    user_data_template   = optional(string)<br>    networks = map(object({<br>      ip_address = optional(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | The amount of memory to allocate to each instance in MB. | `number` | `512` | no |
| <a name="input_networks"></a> [networks](#input\_networks) | Networks is a maps of network configuration parameters. Map key is the network name. These are used to create a Libvirt network which will be used by the instances. | <pre>map(object({<br>    mode      = string<br>    domain    = string<br>    addresses = list(string)<br>    dns = optional(object({<br>      enabled    = optional(bool)<br>      local_only = optional(bool)<br>    }))<br>  }))</pre> | <pre>{<br>  "example": {<br>    "addresses": [<br>      "192.168.125.0/24"<br>    ],<br>    "domain": "example.com",<br>    "mode": "nat"<br>  }<br>}</pre> | no |
| <a name="input_source_volume"></a> [source\_volume](#input\_source\_volume) | The name of the volume to use as a base for the instances. It must be in the LibVirt default pool. | `string` | `null` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | The public key to add to the user's authorized\_keys file. | `string` | `null` | no |
| <a name="input_user"></a> [user](#input\_user) | The user to create on the instances. | `string` | `"ubuntu"` | no |
| <a name="input_vcpu"></a> [vcpu](#input\_vcpu) | The number of virtual CPUs to allocate to each instance. | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instances_with_additional_disks"></a> [instances\_with\_additional\_disks](#output\_instances\_with\_additional\_disks) | A map of instance names with additional disks to the size of the additional disk in GB. |
| <a name="output_ip_addresses"></a> [ip\_addresses](#output\_ip\_addresses) | IP addresses of the instances |
| <a name="output_root_password"></a> [root\_password](#output\_root\_password) | A random password for the user root. |
<!-- END_TF_DOCS -->
<!-- markdownlint-enable MD033 -->

## Dependencies

- [Terraform](https://www.terraform.io/downloads.html) `>= 1.3.0`
  - Although it may work with previous versions, it has not been tested.
  - I recommend using [tfenv](https://github.com/tfutils/tfenv) to manage Terraform versions.
- [pre-commit](https://pre-commit.com/) `== 3.3.2`
  - This repository uses [pre-commit](https://pre-commit.com/) hooks to run some validations before committing new changes. You must install it in order to run the hooks.
  - You can install it using [pip](https://pip.pypa.io/en/stable/installing/): `pip install -r requirements.txt`
  - Then, install the git hook scripts: `pre-commit install`
- [terraform-docs](https://terraform-docs.io/user-guide/installation/) `== v0.16.0`
- [tflint](https://github.com/terraform-linters/tflint) `== v0.47.0`

## Authors

Module is maintained by [Dyego Alexandre Eugenio](https://github.com/dyegoe)

## License

Apache 2 Licensed. See [LICENSE](https://github.com/dyegoe/terraform-libvirt/tree/master/LICENSE) for full details.
