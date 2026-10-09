resource "google_compute_forwarding_rule" "forwarding_rule" {
  name       = var.forwarding_rule_name
  target     = google_compute_target_http_proxy.http_proxy.id
  port_range = var.forwarding_rule_port_range
  load_balancing_scheme = var.load_balancing_scheme
  ip_protocol = var.ip_protocol
  ip_address = var.ip_address
}

resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "${var.forwarding_rule_name}-http-proxy"
  url_map = google_compute_url_map.default.id
}

resource "google_compute_url_map" "default" {
  for_each = var.url_maps
  name            = "${var.forwarding_rule_name}-url-map"
  default_service = each.value.default_service
  dynamic "host_rule" {
    for_each = each.value.host_rule
    content {
      hosts        = host_rule.value.hosts
      path_matcher = host_rule.value.path_matcher
    }
  }
  dynamic "path_matcher" {
    for_each = each.value.path_matcher
    content {
      name            = path_matcher.value.name
      default_service = path_matcher.value.default_service
      dynamic "path_rule" {
        for_each = path_matcher.value.path_rule
        content {
          paths   = path_rule.value.paths
          service = path_rule.value.service
        }
      }
    }
  }
}