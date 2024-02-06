output "ip_addresses" {
  value = {
    for instance in libvirt_domain.name : instance.name => flatten([
      for network_interface in instance.network_interface : network_interface.addresses
    ])
  }
  description = "IP addresses of the instances"
}

output "root_password" {
  value       = random_password.this.result
  description = "A random password for the user root."
  sensitive   = true
}

output "instances_with_additional_disks" {
  value       = local.instances_with_additional_disks
  description = "A map of instance names with additional disks to the size of the additional disk in GB."
}
