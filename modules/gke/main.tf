resource "google_container_cluster" "autopilot_cluster" {
  count            = var.enable_autopilot ? 1 : 0
  name             = var.autopilot_cluster_name
  location         = var.location
  network          = var.network
  subnetwork       = var.subnetwork

  # Conflicting arguments are entirely removed from this block text structure
}

resource "google_container_cluster" "cluster" {
    count          = var.enable_autopilot ? 0 : 1
    name              = var.cluster_name
    location          = var.location
    remove_default_node_pool =  var.remove_default_node_pool
    initial_node_count = var.initial_node_count
    network = var.network
    subnetwork = var.subnetwork
    deletion_protection = var.deletion_protection
}

resource "google_container_node_pool" "nodes" {
    # count = (var.remove_default_node_pool && !var.enable_autopilot) ? 1 : 0
    cluster = google_container_cluster.cluster[0].name
    for_each = (var.remove_default_node_pool && !var.enable_autopilot) ? var.node_pools : {}
    name = each.value.name
    location = each.value.location
    node_count = each.value.node_count
    node_config {
        preemptible = each.value.preemptible
        machine_type = each.value.machine_type
        service_account = each.value.service_account
        oauth_scopes = each.value.oauth_scopes
    }
    autoscaling {
        min_node_count = each.value.min_node_count
        max_node_count = each.value.max_node_count
        location_policy = each.value.location_policy
    }
    network_config {
        enable_private_nodes = each.value.enable_private_nodes
    }
}