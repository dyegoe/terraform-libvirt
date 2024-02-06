resource "libvirt_network" "this" {
  for_each  = var.networks
  name      = each.key
  mode      = each.value.mode
  domain    = each.value.domain
  addresses = each.value.addresses
  dns {
    enabled    = each.value.dns == null ? true : each.value.dns.enabled != null ? each.value.dns.enabled : true
    local_only = each.value.dns == null ? false : each.value.dns.local_only != null ? each.value.dns.local_only : false
  }
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

resource "libvirt_volume" "additional" {
  for_each = local.instances_with_additional_disks
  name     = "${each.key}-additional.img"
  pool     = "default"
  format   = "qcow2"
  size     = each.value.size * 1073741824
}

data "template_file" "user_data" {
  for_each = var.instances
  template = each.value.bastion ? file("${path.module}/templates/cloud-config-bastion.yaml") : each.value.user_data_template != null ? each.value.user_data_template : file("${path.module}/templates/cloud-config.yaml")

  vars = {
    user           = each.value.user != null ? each.value.user : var.user
    groups         = join(",", each.value.groups != null ? each.value.groups : var.groups)
    ssh_public_key = each.value.ssh_public_key != null ? each.value.ssh_public_key : var.ssh_public_key
    hostname       = each.key
    domain         = var.networks[keys(each.value.networks)[0]].domain
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

  cpu {
    mode = "host-passthrough"
  }

  dynamic "network_interface" {
    for_each = { for k, v in each.value.networks : k => v if v.ip_address == null }
    iterator = network_without_ip
    content {
      network_id     = libvirt_network.this[network_without_ip.key].id
      wait_for_lease = true
      hostname       = each.key
    }
  }

  dynamic "network_interface" {
    for_each = { for k, v in each.value.networks : k => v if v.ip_address != null }
    iterator = network_with_ip
    content {
      network_id     = libvirt_network.this[network_with_ip.key].id
      wait_for_lease = true
      addresses      = [network_with_ip.value.ip_address]
      hostname       = each.key
    }
  }


  disk {
    volume_id = libvirt_volume.this[each.key].id
  }

  dynamic "disk" {
    for_each = length(lookup(local.instances_with_additional_disks, each.key, [])) != 0 ? [1] : []
    content {
      volume_id = libvirt_volume.additional[each.key].id
    }
  }

  depends_on = [libvirt_network.this, libvirt_volume.this, libvirt_volume.additional]
}
