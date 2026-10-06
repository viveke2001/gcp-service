variable "forwarding_rule_name" {
  description = "The name of the forwarding rule"
  type        = string
}
variable "forwarding_rule_port_range" {
  description = "The port range for the forwarding rule"
  type        = string
}
variable "load_balancing_scheme" {
  description = "The load balancing scheme for the forwarding rule"
  type        = string
  default = "EXTERNAL_MANAGED"
}
variable "ip_protocol" {
  description = "The IP protocol for the forwarding rule"
  type        = string
  default = "TCP"
}
variable "ip_address" {
  description = "The IP address for the forwarding rule"
  type        = string
  default     = null
}
