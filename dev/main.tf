module "network" {      
    source = "../modules/network"
    vpc_name = "my-vpc"
    subnetworks = {
        "public-subnet-1" = {
            ip_cidr_range = "10.0.1.0/24"
            region = "us-central1"
            stack_type = "IPV4_ONLY"
            is_public = true
            secondary_ip_range = []
        },
        "private-subnet-1" = {
            ip_cidr_range = "10.0.2.0/24"
            region = "us-central1"
            stack_type = "IPV4_ONLY"
            is_public = false
            secondary_ip_range = []
        }
    }
    firewall_rules = {
      "allow-tcp" = {
        allow = [
          {
            protocol = "tcp"
            ports    = ["22", "80", "443"]
          }
        ]
        source_ranges = ["0.0.0.0/0"]
        target_tags = ["web-server"]
      }
      
    }
}

module "gke" {
  source = "../modules/gke"
  cluster_name = "my-gke-cluster"
  location = "us-central1-a"
  network = module.network.vpc_name
  subnetwork = module.network.subnetwork_name["private-subnet-1"]
  deletion_protection = false 
  node_pools = {
    "my-node-pool" = {
      name = "my-node-pool"
      location = "us-central1-a"
      node_count = 1
      preemptible = true
      machine_type = "e2-medium"
      service_account = null
      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform"
      ]
      min_node_count = 1
      max_node_count = 5
      location_policy = "BALANCED"
      enable_private_nodes = true
    }
  }
}