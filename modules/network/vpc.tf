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

resource "google_compute_instance_template" "template" {
  name         = "my-instance-template"
  machine_type = "e2-medium"

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = google_compute_network.name.name
    subnetwork = google_compute_subnetwork.private.name
  }

  tags = ["web-server"]
}

resource "google_compute_region_instance_group_manager" "igm" {
  name               = "my-region-instance-group-manager"
  region             = "us-central1"
  base_instance_name = "my-instance"
  version {
    instance_template = google_compute_instance_template.template.id
  }
  target_size        = 2
}

resource "google_compute_region_autoscaler" "autoscaler" {
  name    = "my-autoscaler"
  region   = "us-central1"
  target  = google_compute_region_instance_group_manager.igm.id

  autoscaling_policy {
    max_replicas    = 5
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.6
    }
  }
}

resource "google_compute_health_check" "health_check" {
  name               = "my-health-check"
  check_interval_sec = 5
  timeout_sec        = 5
  healthy_threshold  = 2
  unhealthy_threshold = 2

  tcp_health_check {
    port = 80
  }
}

resource "google_compute_backend_service" "backend_service" {
  name                  = "my-backend-service"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 10
  health_checks         = [google_compute_health_check.health_check.id]
  backend {
    group = google_compute_region_instance_group_manager.igm.instance_group
  }
  load_balancing_scheme = "EXTERNAL_MANAGED"
}