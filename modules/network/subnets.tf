resource "google_compute_subnetwork" "public" {
  name = "my-public-subnet"
  network = google_compute_network.name.name
  ip_cidr_range = "10.0.1.0/24"
  region = local.region
  stack_type = "IPV4_ONLY"
}

resource "google_compute_subnetwork" "private_01" {
  name = "my-private-subnet-1"
  network = google_compute_network.name.name
  region = local.region
  stack_type = "IPV4_ONLY"
  ip_cidr_range = "10.0.2.0/24"
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "private_02" {
  name = "my-private-subnet-2"
  network = google_compute_network.name.name
  region = local.region
  stack_type = "IPV4_ONLY"
  ip_cidr_range = "10.0.3.0/24"
  private_ip_google_access = true
}