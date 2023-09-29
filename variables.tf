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

variable "instances" {
  type = map(object({
    memory    = number
    vcpu      = number
    autostart = bool
  }))
  default     = {}
  description = "A map of instance names to instance configurations."
}
