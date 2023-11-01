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
  description = "Network configuration parameters. These are used to create a Libvirt network which will be used by the instances."
}

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
  default     = null
  description = "The public key to add to the user's authorized_keys file."
}

variable "source_volume" {
  type        = string
  default     = null
  description = "The name of the volume to use as a base for the instances. It must be in the LibVirt default pool."
}

variable "memory" {
  type        = number
  default     = 512
  description = "The amount of memory to allocate to each instance in MB."
}

variable "vcpu" {
  type        = number
  default     = 1
  description = "The number of virtual CPUs to allocate to each instance."
}

variable "autostart" {
  type        = bool
  default     = true
  description = "Whether to automatically start the instances when the host boots."
}

variable "disk_size" {
  type        = number
  default     = 3
  description = "The size of the disk to create for each instance in GB."
}

variable "additional_disk" {
  type        = bool
  default     = false
  description = "Whether to create an additional disk for each instance."
}

variable "additional_disk_size" {
  type        = number
  default     = 1
  description = "The size of the additional disk to create for each instance in GB."
}

variable "instances" {
  type = map(object({
    user                 = optional(string)
    groups               = optional(list(string))
    ssh_public_key       = optional(string)
    source_volume        = optional(string)
    memory               = optional(number)
    vcpu                 = optional(number)
    autostart            = optional(bool)
    disk_size            = optional(number)
    additional_disk      = optional(bool)
    additional_disk_size = optional(number)
    ip_address           = optional(string)
  }))
  default     = {}
  description = "A map of instance names to instance configurations. disk_size is in GB."
}
