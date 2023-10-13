resource "libvirt_volume" "source" {
  name   = "terraform-libvirt-source.img"
  pool   = "default"
  source = var.source_disk_image
  format = "qcow2"
}

resource "libvirt_volume" "this" {
  for_each       = var.instances
  name           = "${each.key}.img"
  pool           = "default"
  base_volume_id = libvirt_volume.source.id
  format         = "qcow2"
  size           = each.value.disk_size * 1073741824
}

data "template_file" "user_data" {
  for_each = var.instances
  template = file("${path.module}/templates/cloud-config.yaml")

  vars = {
    user           = var.user
    groups         = join(",", var.groups)
    ssh_public_key = var.ssh_public_key
    hostname       = each.key
    domain         = var.network.domain
  }
}

resource "libvirt_network" "this" {
  name      = var.network.name
  mode      = var.network.mode
  domain    = var.network.domain
  addresses = var.network.addresses
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

  dynamic "network_interface" {
    for_each = each.value.ip_address == null ? [1] : []
    content {
      network_id     = libvirt_network.this.id
      wait_for_lease = true
      hostname       = each.key
    }
  }

  dynamic "network_interface" {
    for_each = each.value.ip_address != null ? [1] : []
    content {
      network_id     = libvirt_network.this.id
      wait_for_lease = true
      addresses      = [each.value.ip_address]
      hostname       = each.key
    }
  }


  disk {
    volume_id = libvirt_volume.this[each.key].id
  }
}
