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
variable "url_maps" {
  type = map(object({
    default_service = string
    host_rule = optional(list(object({
      hosts        = list(string)
      path_matcher = string
    })), [])
    path_matcher = optional(list(object({
      name            = string
      default_service = string
      path_rule       = optional(list(object({
        paths   = list(string)
        service = string
      })), [])
    })), [])
  }))
}
variable "backend_services" {
  type = map(object({
    name = string
    health_check_name = string
    protocol = string
    port_name = string
    timeout_sec = optional(number, 30)
    check_interval_sec = optional(number, 5)
    healthy_threshold = optional(number, 2)
    unhealthy_threshold = optional(number, 2)
    http_health_check = object({
      port = number
      request_path = string
    })
  }))
}
