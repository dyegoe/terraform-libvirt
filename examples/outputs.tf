output "ip_address" {
  value       = module.example.ip_address
  description = "IP address of the instances"
}

output "ssh_command" {
  value       = module.example.ssh_command
  description = "SSH command to connect to the instance"
}

output "root_password" {
  value       = module.example.root_password
  description = "A random password for the user root."
  sensitive   = true
}
