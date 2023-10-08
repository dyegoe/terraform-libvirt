variable "user" {
  type        = string
  default     = "ubuntu"
  description = "The user to create on the instances."
}

variable "groups" {
  type        = list(string)
  default     = ["users", "admin"]
  description = "The groups to add the user to."
}

variable "ssh_public_key" {
  type        = string
  description = "The public key to add to the user's authorized_keys file."
}

variable "source_disk_image" {
  type        = string
  description = "The path to the source disk image to use for the instances. This image will be copied to a new volume for each instance. The image must be in qcow2 format."
}

variable "network" {
  type = object({
    name      = string
    mode      = string
    domain    = string
    addresses = list(string)
  })
  default = {
    name      = "example"
    mode      = "nat"
    domain    = "example.com"
    addresses = ["192.168.125.0/24"]
  }
  description = "The network configuration for the instances."
}

variable "instances" {
  type = map(object({
    memory     = number
    vcpu       = number
    autostart  = bool
    disk_size  = number
    ip_address = optional(string, null)
  }))
  default     = {}
  description = "A map of instance names to instance configurations. disk_size is in GB."
}
