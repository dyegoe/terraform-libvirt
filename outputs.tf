output "ip_address" {
  value = {
    for instance in libvirt_domain.name : instance.name => instance.network_interface[0].addresses[0]
  }
  description = "IP addresses of the instances"
}

output "ssh_command" {
  value = {
    for instance in libvirt_domain.name : instance.name => "ssh ${var.user}@${instance.network_interface[0].addresses[0]}"
  }
  description = "SSH commands to connect to the instances"
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
