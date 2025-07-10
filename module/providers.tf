provider "google" {
  project = local.project
  region  = local.region
}

terraform {
  required_version = ">= 1.8.5"
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.41.0"
    }
  }
}