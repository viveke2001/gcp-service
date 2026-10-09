resource "google_compute_backend_service" "backend" {
    for_each = var.backend_services
    name = each.value.name
    health_checks = [google_compute_health_check.health_check[each.key].id]
    protocol = each.value.protocol
    port_name = each.value.port_name
    timeout_sec = each.value.timeout_sec
}

resource "google_compute_health_check" "health_check" {
    for_each = { for k, v in var.backend_services : k => v if length(v.health_checks) > 0 }
    name = each.value.health_checks[0]
    check_interval_sec = each.value.check_interval_sec
    timeout_sec = each.value.timeout_sec
    healthy_threshold = each.value.healthy_threshold
    unhealthy_threshold = each.value.unhealthy_threshold

    dynamic "http_health_check" {
        for_each = each.value.http_health_check != null ? [each.value.http_health_check] : []
        content {
            port = http_health_check.value.port
            request_path = http_health_check.value.request_path
        }
    }
}