resource "google_compute_subnetwork" "subnetwork" {
  for_each = var.subnetworks
  name = each.key
  network = google_compute_network.name.name
  ip_cidr_range = each.value.ip_cidr_range
  region = each.value.region
  stack_type = each.value.stack_type
  dynamic "secondary_ip_range" {
    for_each = each.value.secondary_ip_range
    content {
      range_name = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }
}

