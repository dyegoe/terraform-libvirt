resource "libvirt_volume" "this" {
  for_each = var.instances
  name     = "${each.key}.img"
  pool     = "default"
  source   = var.source_disk_image
  format   = "qcow2"
}

data "template_file" "user_data" {
  for_each = var.instances
  template = file("${path.module}/config/cloud-init.yaml")

  vars = {
    user           = var.user
    groups         = join(",", var.groups)
    ssh_public_key = var.ssh_public_key
    hostname       = each.key
  }
}

resource "libvirt_cloudinit_disk" "this" {
  for_each  = var.instances
  name      = "${each.key}-cloudinit.img"
  user_data = data.template_file.user_data[each.key].rendered
}

resource "libvirt_domain" "name" {
  for_each  = var.instances
  name      = each.key
  memory    = each.value.memory
  vcpu      = each.value.vcpu
  autostart = each.value.autostart
  cloudinit = libvirt_cloudinit_disk.this[each.key].id

  network_interface {
    network_name   = "default"
    wait_for_lease = true
    hostname       = each.key
  }

  disk {
    volume_id = libvirt_volume.this[each.key].id
  }
}
