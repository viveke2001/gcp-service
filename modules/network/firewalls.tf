resource "google_compute_firewall" "rules" {
  for_each = var.firewall_rules

  name        = "${var.vpc_name}-${each.key}"
  network     = google_compute_network.name.name
  direction   = each.value.direction
  priority    = each.value.priority
  
  source_ranges      = each.value.direction == "INGRESS" ? each.value.source_ranges : null
  destination_ranges = each.value.direction == "EGRESS" ? each.value.destination_ranges : null
  
  target_tags = length(each.value.target_tags) > 0 ? each.value.target_tags : null
  source_tags = length(each.value.source_tags) > 0 ? each.value.source_tags : null

  dynamic "allow" {
    for_each = each.value.allow
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  dynamic "deny" {
    for_each = each.value.deny
    content {
      protocol = deny.value.protocol
      ports    = deny.value.ports
    }
  }
}
