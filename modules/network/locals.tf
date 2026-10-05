locals {
  project = "project-a18c6c91-37cd-470f-9a7"
  region  = "us-central1"
  apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "logging.googleapis.com"
  ]
  private_regions = distinct([
    for k, v in var.subnetworks : v.region if !v.is_public
  ])
}