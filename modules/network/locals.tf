locals {
  private_regions = distinct([
    for k, v in var.subnetworks : v.region if !v.is_public
  ])
}