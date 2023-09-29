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
module "example" {
  source = "github.com/dyegoe/terraform-libvirt?ref=main"

  source_disk_image = "/var/lib/libvirt/images/jammy-server-cloudimg-amd64.img"
  instances = {
    "example1" = {
      memory    = 512
      vcpu      = 1
      autostart = true
    }
    "example2" = {
      memory    = 512
      vcpu      = 1
      autostart = true
    }
  }
}
```

<!-- markdownlint-disable MD033 -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4 |
| <a name="requirement_libvirt"></a> [libvirt](#requirement\_libvirt) | 0.7.1 |
| <a name="requirement_template"></a> [template](#requirement\_template) | 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_libvirt"></a> [libvirt](#provider\_libvirt) | 0.7.1 |
| <a name="provider_template"></a> [template](#provider\_template) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [libvirt_cloudinit_disk.this](https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.1/docs/resources/cloudinit_disk) | resource |
| [libvirt_domain.name](https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.1/docs/resources/domain) | resource |
| [libvirt_volume.this](https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.1/docs/resources/volume) | resource |
| [template_file.user_data](https://registry.terraform.io/providers/hashicorp/template/2.2.0/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_groups"></a> [groups](#input\_groups) | The groups to add the user to. | `list(string)` | <pre>[<br>  "users",<br>  "admin"<br>]</pre> | no |
| <a name="input_instances"></a> [instances](#input\_instances) | A map of instance names to instance configurations. | <pre>map(object({<br>    memory    = number<br>    vcpu      = number<br>    autostart = bool<br>  }))</pre> | `{}` | no |
| <a name="input_source_disk_image"></a> [source\_disk\_image](#input\_source\_disk\_image) | The path to the source disk image to use for the instances. This image will be copied to a new volume for each instance. The image must be in qcow2 format. | `string` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | The public key to add to the user's authorized\_keys file. | `string` | n/a | yes |
| <a name="input_user"></a> [user](#input\_user) | The user to create on the instances. | `string` | `"ubuntu"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | IP addresses of the instances |
| <a name="output_ssh_command"></a> [ssh\_command](#output\_ssh\_command) | SSH commands to connect to the instances |
<!-- END_TF_DOCS -->
<!-- markdownlint-enable MD033 -->

## Examples

You can find an example [here](examples/) of how to use this module.

## Dependencies

- [Terraform](https://www.terraform.io/downloads.html) `>= 1.4.0`
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
