resource "google_project_service" "api" {
  for_each = local.apis
  service = each.value

  disable_on_destroy = false
}

resource "google_compute_network" "name" {
  name = "my-vpc"
  routing_mode = "REGIONAL"
  auto_create_subnetworks = false
  delete_default_routes_on_create = true

  depends_on = [ google_project_service.api ]
}

resource "google_compute_route" "name" {
  name = "my-route"
  dest_range = "0.0.0.0/0"
  network = google_compute_network.name.name
}