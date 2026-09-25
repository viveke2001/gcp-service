# resource "google_service_account" "default" {
#     account_id = "service-account-id"
#     display_name = "Service Account"
# }
resource "google_container_cluster" "primary" {
  name = "my-gke-cluster"
  location = "us-central1-a"
  remove_default_node_pool = true 
  initial_node_count = 1 
  deletion_protection = false
  network = google_compute_network.name.name 
  subnetwork = google_compute_subnetwork.private_01.name 
}

resource "google_container_node_pool" "nodes" {
    name = "my-node-pool"
    location = "us-central1-a"
    cluster = google_container_cluster.primary.name 
    node_count = 1
    node_config {
      preemptible = true 
      machine_type = "e2-medium"
      # service_account = google_service_account.default.email 
      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform"
      ]
    }
    network_config {
      enable_private_nodes = true
    }
    autoscaling {
      min_node_count = 1 
      max_node_count = 5
      location_policy = "BALANCED"
    }
}

resource "google_service_account" "gke_sa" {
  account_id   = "gke-service-account"
  display_name = "GKE Service Account"
}

resource "google_project_iam_member" "gke_sa_role" {
  project = local.project
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

resource "google_service_account_iam_member" "gke_sa_iam" {
  service_account_id = google_service_account.gke_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${local.project}.svc.id.goog[default/my-service-account]"
}