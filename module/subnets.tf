resource "google_compute_subnetwork" "name" {
  name = "my-subnet"
  network = google_compute_network.name.name
  ip_cidr_range = "10.0.0.0/16"
  region = local.region
  stack_type = "IPV4_OBLY"
}

resource "google_compute_subnetwork" "name" {
  name = "my-private-subnet"
  network = google_compute_network.name.name
  region = local.region
  stack_type = "IPV4_ONLY"
  ip_cidr_range = "10.0.1.0/16"
}