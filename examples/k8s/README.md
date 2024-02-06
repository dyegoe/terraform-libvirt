# Example

This is an example on how to use the `terraform-libvirt` module.

This example will create 4 instances with the following names:

- `master`
- `node1`
- `node2`
- `node3`

And it is ready to apply [ansible-k8s-cluster](https://github.com/dyegoe/ansible-k8s-cluster) on it and create a Kubernetes cluster.

## Usage

```bash
export TF_VAR_ssh_public_key="$(cat ~/.ssh/id_rsa.pub)"
terraform init
terraform apply
```

or you can create `terraform.tfvars` file with the following content:

```hcl
ssh_public_key = "ssh-rsa AAAAB..."
```

There are also some `Makefile` targets to help you:

```bash
make # It will initialize terraform, plan and apply
make clean # It will destroy the instances and remove the terraform state
```

For more information about `Makefile` targets, run `make help`.

<!-- markdownlint-disable MD033 -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_libvirt"></a> [libvirt](#requirement\_libvirt) | >=0.7.1 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_example"></a> [example](#module\_example) | ../../. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | The public key to add to the user's authorized\_keys file. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instances_with_additional_disks"></a> [instances\_with\_additional\_disks](#output\_instances\_with\_additional\_disks) | A map of instance names with additional disks to the size of the additional disk in GB. |
| <a name="output_ip_addresses"></a> [ip\_addresses](#output\_ip\_addresses) | IP address of the instances |
| <a name="output_root_password"></a> [root\_password](#output\_root\_password) | A random password for the user root. |
<!-- END_TF_DOCS -->
<!-- markdownlint-enable MD033 -->
