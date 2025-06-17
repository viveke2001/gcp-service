provider "google" {
  project = "shaped-complex-461709-q4"
  region  = "us-central1"
}
resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = "us-central1"

 
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  cluster    = google_container_cluster.primary.name
  location   = google_container_cluster.primary.location
  node_count = 1

  node_config {
    machine_type = "e2-medium"  # small, cost-effective
    disk_size_gb = 50
    disk_type    = "pd-standard"  # use "pd-standard" to reduce SSD usage

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    metadata = {
      disable-legacy-endpoints = "true"
    }

    labels = {
      env = "dev"
    }

    tags = ["gke-node"]
  }

  management {
    auto_upgrade = true
    auto_repair  = true
  }
}
