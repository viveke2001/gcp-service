resource "google_project_service" "api" {
  for_each = toset(local.apis)
  service = each.key

  disable_on_destroy = false
}

resource "google_compute_network" "name" {
  name = "my-vpc"
  routing_mode = "REGIONAL"
  auto_create_subnetworks = false

  depends_on = [ google_project_service.api ]
}

resource "google_compute_firewall" "name" {
  name = "my-firewall"
  network = google_compute_network.name.name
  allow {
    protocol = "tcp"
    ports = ["22", "80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["web-server"]
}

resource "google_compute_instance" "default" {
  name         = "my-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = google_compute_network.name.name
    subnetwork = google_compute_subnetwork.public.name
    access_config {
      // Ephemeral public IP
    }
  }

  tags = ["web-server"]
}

resource "google_compute_router" "router" {
  name   = "my-router"
  network = google_compute_network.name.name
  region  = "us-central1"
}

resource "google_compute_router_nat" "nat" {
  name   = "my-nat"
  router = google_compute_router.router.name
  region = google_compute_router.router.region

  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_instance" "private" {
  name         = "my-private-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network = google_compute_network.name.name
    subnetwork = google_compute_subnetwork.private.name
    
  }

  tags = ["web-server"]
}