resource "libvirt_network" "this" {
  name      = var.network.name
  mode      = var.network.mode
  domain    = var.network.domain
  addresses = var.network.addresses
}

resource "random_password" "this" {
  length  = 8
  special = false
}

resource "random_password" "salt" {
  length  = 8
  special = false
}
resource "htpasswd_password" "this" {
  password = random_password.this.result
  salt     = random_password.salt.result
}

resource "libvirt_volume" "this" {
  for_each         = var.instances
  name             = "${each.key}.img"
  pool             = "default"
  base_volume_name = each.value.source_volume != null ? each.value.source_volume : var.source_volume
  format           = "qcow2"
  size             = (each.value.disk_size != null ? each.value.disk_size : var.disk_size) * 1073741824
}

data "template_file" "user_data" {
  for_each = var.instances
  template = file("${path.module}/templates/cloud-config.yaml")

  vars = {
    user           = each.value.user != null ? each.value.user : var.user
    groups         = join(",", each.value.groups != null ? each.value.groups : var.groups)
    ssh_public_key = each.value.ssh_public_key != null ? each.value.ssh_public_key : var.ssh_public_key
    hostname       = each.key
    domain         = var.network.domain
    root_password  = htpasswd_password.this.sha512
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
  memory    = each.value.memory != null ? each.value.memory : var.memory
  vcpu      = each.value.vcpu != null ? each.value.vcpu : var.vcpu
  autostart = each.value.autostart != null ? each.value.autostart : var.autostart
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
