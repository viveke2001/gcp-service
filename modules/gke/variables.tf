variable "cluster_name" {}
variable "location" {}
variable "enable_autopilot" {
  type    = bool
  default = false
}
variable "remove_default_node_pool" {
  type    = bool
  default = true
}
variable "initial_node_count" {
  type    = number
  default = 1
}
variable "network" {}
variable "subnetwork" {}
variable "node_pools" {
  type = map(object({
    name               = string
    node_count         = number
    location           = string
    machine_type       = string
    preemptible        = bool
    min_node_count     = number
    max_node_count     = number
    location_policy    = optional(string, "BALANCED")
    service_account    = optional(string, null)
    oauth_scopes       = optional(list(string), [])
    enable_private_nodes = optional(bool, true)
  }))
}
variable "autopilot_cluster_name" {
  default = "autopilot-cluster"
}
variable "deletion_protection" {
  type    = bool
  default = false
}