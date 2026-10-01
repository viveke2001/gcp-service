variable "vpc_name" {}
variable "routing_mode" {
   default = "REGIONAL"
   description = "The network wide routing mode to use"
   type = string
}
variable "auto_create_subnetworks" {
   default = false
   description = "Whether to automatically create subnetworks"
   type = bool
}
variable "bgp_best_path_selection_mode" {
   default = "LEGACY"
   description = "The BGP best path selection mode to use"
   type = string
}
variable "mtu" {
  default = 1460
  description = "Maximum Transmission Unit in bytes"
  type = number
}
variable "enable_ula_internal_ipv6" {
  default = false
  description = "Whether to enable ULA internal IPv6"
  type = bool
}
variable "network_firewall_policy_enforcement_order" {
  default = "AFTER_CLASSIC_FIREWALL"
  description = "The order in which firewall policies are enforced"
  type = string
}
variable "subnetworks" {
  description = "A list of subnetwork configurations"
  type = map(object({
    ip_cidr_range = string
    region = string
    stack_type = string
    is_public = bool
    secondary_ip_range = list(object({
      range_name = string
      ip_cidr_range = string
    }))
  }))
  default = {}
}