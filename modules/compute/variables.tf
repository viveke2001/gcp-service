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
variable "instance_templates" {
  type = map(object({
    name = string
    machine_type = string
    tags = list(string)
    automatic_restart = optional(bool, true)
    disk = list(object({
      source_image = string
      auto_delete = optional(bool, true)
    }), [])
    network = string
    subnetwork = string
  }))
}
variable "instance_groups" {
  type = map(object({
    name = string
    region = string
    base_instance_name = string
    target_size = optional(number, 1)
    instance_template = string
    autoscaling_policy = object({
      max_replicas = optional(number, 10)
      min_replicas = optional(number, 1)
      cooldown_period = optional(number, 60)
      scale_in_control = object({
        time_window_sec = optional(number, 300)
      })
      cpu_utilization = object({
        target = optional(number, 0.8)
      })
    })
  }))
}
