resource "google_compute_router" "router" {
  for_each = toset(local.private_regions)
  name     = "${var.vpc_name}-router-${each.value}"
  region   = each.value
  network  = google_compute_network.name.id
}

resource "google_compute_router_nat" "nat" {
  for_each                           = toset(local.private_regions)
  name                               = "${var.vpc_name}-nat-${each.value}"
  router                             = google_compute_router.router[each.value].name
  region                             = each.value
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}