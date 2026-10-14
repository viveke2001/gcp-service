resource "google_container_cluster" "cluster" {
    name              = var.cluster_name
    location          = var.location
    enable_autopilot = var.enable_autopilot
    remove_default_node_pool = var.enable_autopilot ? null : var.remove_default_node_pool
    initial_node_count = var.enable_autopilot ? null : var.initial_node_count
    network = var.network
    subnetwork = var.subnetwork
}

resource "google_container_node_pool" "nodes" {
    # count = (var.remove_default_node_pool && !var.enable_autopilot) ? 1 : 0
    cluster = google_container_cluster.cluster.name
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