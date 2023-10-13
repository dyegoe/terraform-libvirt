output "ip_address" {
  value       = module.example.ip_address
  description = "IP address of the instances"
}

output "ssh_command" {
  value       = module.example.ssh_command
  description = "SSH command to connect to the instance"
}
