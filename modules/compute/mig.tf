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

resource "google_compute_region_instance_group_manager" "mig" {
  for_each = var.instance_groups
  name               = each.value.name
  region             = each.value.region
  base_instance_name = each.value.base_instance_name
  version {
    instance_template = google_compute_instance_template.instance_template[each.key].id
  }
  target_size        = each.value.target_size
  lifecycle {
    ignore_changes = [ target_size ]
  }
}

resource "google_compute_region_autoscaler" "autoscaler" {
  for_each = var.instance_groups
  name    = "${each.value.name}-autoscaler"
  region  = each.value.region
  target  = google_compute_region_instance_group_manager.mig[each.key].id

  autoscaling_policy {
    max_replicas    = each.value.autoscaling_policy.max_replicas
    min_replicas    = each.value.autoscaling_policy.min_replicas
    cooldown_period = each.value.autoscaling_policy.cooldown_period
    scale_in_control {
      time_window_sec = each.value.autoscaling_policy.scale_in_control.time_window_sec
    }
    cpu_utilization {
      target = each.value.autoscaling_policy.cpu_utilization.target
    }
    
  }
}