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
  # target_tags = ["web-server"]
}

# resource "google_compute_instance" "default" {
#   name         = "my-instance"
#   machine_type = "e2-medium"
#   zone         = "us-central1-a"

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-11"
#       labels = {
#         my_label = "value"
#       }
#     }
#   }

#   network_interface {
#     network = google_compute_network.name.name
#     subnetwork = google_compute_subnetwork.public.name
#     access_config {
#       // Ephemeral public IP
#     }
#   }

#   tags = ["web-server"]
# }

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

# resource "google_compute_instance" "private" {
#   name         = "my-private-instance"
#   machine_type = "e2-medium"
#   zone         = "us-central1-a"

#   boot_disk {
#     initialize_params {
#       image = "debian-cloud/debian-11"
#       labels = {
#         my_label = "value"
#       }
#     }
#   }

#   network_interface {
#     network = google_compute_network.name.name
#     subnetwork = google_compute_subnetwork.private.name
    
#   }

#   tags = ["web-server"]
# }

# resource "google_compute_instance_template" "template" {
#   name         = "my-instance-template"
#   machine_type = "e2-medium"

#   disk {
#     source_image = "debian-cloud/debian-11"
#     auto_delete  = true
#     boot         = true
#   }

#   network_interface {
#     network = google_compute_network.name.name
#     subnetwork = google_compute_subnetwork.private.name
#   }

#   tags = ["web-server"]
# }

# resource "google_compute_region_instance_group_manager" "igm" {
#   name               = "my-region-instance-group-manager"
#   region             = "us-central1"
#   base_instance_name = "my-instance"
#   version {
#     instance_template = google_compute_instance_template.template.id
#   }
#   # target_size        = 2
# }

# resource "google_compute_region_autoscaler" "autoscaler" {
#   name    = "my-autoscaler"
#   region   = "us-central1"
#   target  = google_compute_region_instance_group_manager.igm.id

#   autoscaling_policy {
#     max_replicas    = 5
#     min_replicas    = 1
#     cooldown_period = 60

#     cpu_utilization {
#       target = 0.6
#     }
#   }
# }

# resource "google_compute_health_check" "health_check" {
#   name               = "my-health-check"
#   check_interval_sec = 5
#   timeout_sec        = 5
#   healthy_threshold  = 2
#   unhealthy_threshold = 2

#   tcp_health_check {
#     port = 80
#   }
# }

# resource "google_compute_backend_service" "backend_service" {
#   name                  = "backend-service"
#   protocol              = "HTTP"
#   port_name             = "http"
#   # timeout_sec           = null
#   # health_checks         = [google_compute_health_check.health_check.id]
#   backend {
#     group = google_compute_region_network_endpoint_group.neg.id
#   }
#   load_balancing_scheme = "EXTERNAL_MANAGED"
# }

# resource "google_compute_url_map" "url_map" {
#   name            = "my-url-map"
#   default_service = google_compute_backend_service.backend_service.id
# }

# resource "google_compute_target_http_proxy" "http_proxy" {
#   name    = "my-http-proxy"
#   url_map = google_compute_url_map.url_map.id
# }

# resource "google_compute_global_forwarding_rule" "forwarding_rule" {
#   name       = "my-forwarding-rule"
#   target     = google_compute_target_http_proxy.http_proxy.id
#   port_range = "80"
#   load_balancing_scheme = "EXTERNAL_MANAGED"
# }

# resource "google_artifact_registry_repository" "artifact_repo" {
#   location = "us-central1"
#   repository_id = "my-artifact-repo"
#   format = "DOCKER"
#   description = "My Docker Artifact Repository"
# }

# resource "google_cloud_run_service" "cloud_run_service" {
#   name     = "my-cloud-run-service"
#   location = "us-central1"

#   template {
#     spec {
#       service_account_name = google_service_account.cloud_run_sa.email
#       containers {
#         image = "us-docker.pkg.dev/cloudrun/container/hello"
#         ports {
#           container_port = 8080
#         }
#       }
#     }
    
#   }

#   traffic {
#     percent         = 100
#     latest_revision = true
#   }
# }

# resource "google_compute_region_network_endpoint_group" "neg" {
#   name                  = "my-neg"
#   region                = "us-central1"
#   network_endpoint_type = "SERVERLESS"
#   cloud_run {
#     service = google_cloud_run_service.cloud_run_service.name
#   }
# }

# resource "google_service_account" "cloud_run_sa" {
#   account_id   = "cloud-run-sa"
#   display_name = "Cloud Run Service Account"
# }

# resource "google_artifact_registry_repository_iam_member" "ar_reader" {
#   repository = google_artifact_registry_repository.artifact_repo.name
#   role       = "roles/artifactregistry.reader"
#   member     = "serviceAccount:${google_service_account.cloud_run_sa.email}"
# }