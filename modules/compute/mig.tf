resource "google_compute_instance_template" "instance_template" {
  for_each = var.instance_templates
  name        = each.value.name
  machine_type = each.value.machine_type
  tags       = each.value.tags
  scheduling {
    automatic_restart = each.value.automatic_restart
  }
  dynamic "disk" {
    for_each = each.value.disk
    content {
      source_image = disk.value.source_image
      auto_delete = disk.value.auto_delete
    }
  }
  network_interface {
    network = each.value.network
    subnetwork = each.value.subnetwork
  }
}
