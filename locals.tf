locals {
  instances_with_additional_disks = {
    for instance, values in var.instances : instance => {
      size = values.additional_disk_size != null ? values.additional_disk_size : var.additional_disk_size
    } if values.additional_disk == true || (values.additional_disk == null && var.additional_disk == true)
  }
}
