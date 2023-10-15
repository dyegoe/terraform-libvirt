# Terraform LibVirt Module

This module creates a LibVirt domain (instances) using Terraform.

- [Terraform LibVirt Module](#terraform-libvirt-module)
  - [Usage](#usage)
  - [Requirements](#requirements)
  - [Providers](#providers)
  - [Modules](#modules)
  - [Resources](#resources)
  - [Inputs](#inputs)
  - [Outputs](#outputs)
  - [Examples](#examples)
  - [Dependencies](#dependencies)
  - [Authors](#authors)
  - [License](#license)

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
  source            = "github.com/dyegoe/terraform-libvirt?ref=main"
  user              = "ubuntu"
  groups            = ["users", "admin"]
  ssh_public_key    = "ssh-ed25519 AAAA..."
  source_disk_image = "/var/lib/libvirt/images/jammy-server-cloudimg-amd64.img"
  network = {
    name      = "example"
    mode      = "nat"
    domain    = "example.local"
    addresses = ["192.168.200.0/24"]
  }
  instances = {
    "example1" = {
      memory     = 512
      vcpu       = 1
      autostart  = true
      disk_size  = 2
      ip_address = "192.168.200.2"
    }
    "example2" = {
      memory     = 512
      vcpu       = 2
      autostart  = true
      disk_size  = 2
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
  value = module.example.root_password
}
```

<!-- markdownlint-disable MD033 -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_htpasswd"></a> [htpasswd](#requirement\_htpasswd) | 1.0.4 |
| <a name="requirement_libvirt"></a> [libvirt](#requirement\_libvirt) | 0.7.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.5.1 |
| <a name="requirement_template"></a> [template](#requirement\_template) | 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_htpasswd"></a> [htpasswd](#provider\_htpasswd) | 1.0.4 |
| <a name="provider_libvirt"></a> [libvirt](#provider\_libvirt) | 0.7.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [htpasswd_password.this](https://registry.terraform.io/providers/loafoe/htpasswd/1.0.4/docs/resources/password) | resource |
| [libvirt_cloudinit_disk.this](https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.1/docs/resources/cloudinit_disk) | resource |
| [libvirt_domain.name](https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.1/docs/resources/domain) | resource |
| [libvirt_network.this](https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.1/docs/resources/network) | resource |
| [libvirt_volume.source](https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.1/docs/resources/volume) | resource |
| [libvirt_volume.this](https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.1/docs/resources/volume) | resource |
| [random_password.salt](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/password) | resource |
| [random_password.this](https://registry.terraform.io/providers/hashicorp/random/3.5.1/docs/resources/password) | resource |
| [template_file.user_data](https://registry.terraform.io/providers/hashicorp/template/2.2.0/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_groups"></a> [groups](#input\_groups) | The groups to add the user to. | `list(string)` | <pre>[<br>  "users",<br>  "admin"<br>]</pre> | no |
| <a name="input_instances"></a> [instances](#input\_instances) | A map of instance names to instance configurations. disk\_size is in GB. | <pre>map(object({<br>    memory     = number<br>    vcpu       = number<br>    autostart  = bool<br>    disk_size  = number<br>    ip_address = optional(string, null)<br>  }))</pre> | `{}` | no |
| <a name="input_network"></a> [network](#input\_network) | The network configuration for the instances. | <pre>object({<br>    name      = string<br>    mode      = string<br>    domain    = string<br>    addresses = list(string)<br>  })</pre> | <pre>{<br>  "addresses": [<br>    "192.168.125.0/24"<br>  ],<br>  "domain": "example.com",<br>  "mode": "nat",<br>  "name": "example"<br>}</pre> | no |
| <a name="input_source_disk_image"></a> [source\_disk\_image](#input\_source\_disk\_image) | The path to the source disk image to use for the instances. This image will be copied to a new volume for each instance. The image must be in qcow2 format. | `string` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | The public key to add to the user's authorized\_keys file. | `string` | n/a | yes |
| <a name="input_user"></a> [user](#input\_user) | The user to create on the instances. | `string` | `"ubuntu"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | IP addresses of the instances |
| <a name="output_root_password"></a> [root\_password](#output\_root\_password) | A random password for the user root. |
| <a name="output_ssh_command"></a> [ssh\_command](#output\_ssh\_command) | SSH commands to connect to the instances |
<!-- END_TF_DOCS -->
<!-- markdownlint-enable MD033 -->

## Examples

You can find an example [here](example/) of how to use this module.

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
