output "ip_addresses" {
  value       = module.example.ip_addresses
  description = "IP address of the instances"
}

output "root_password" {
  value       = module.example.root_password
  description = "A random password for the user root."
  sensitive   = true
}

output "instances_with_additional_disks" {
  value       = module.example.instances_with_additional_disks
  description = "A map of instance names with additional disks to the size of the additional disk in GB."
}
