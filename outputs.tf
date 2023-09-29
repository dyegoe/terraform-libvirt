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
