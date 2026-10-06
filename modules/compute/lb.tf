resource "google_compute_forwarding_rule" "forwarding_rule" {
  name       = var.forwarding_rule_name
  target     = google_compute_target_http_proxy.http_proxy.id
  port_range = var.forwarding_rule_port_range
  load_balancing_scheme = var.load_balancing_scheme
  ip_protocol = var.ip_protocol
  ip_address = var.ip_address
}

resource "google_compute_target_http_proxy" "default" {
  name    = "${var.forwarding_rule_name}-http-proxy"
  url_map = google_compute_url_map.default.id
}

