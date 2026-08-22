locals {
  required_apis = [
    "compute.googleapis.com",
    "servicenetworking.googleapis.com",
    "vpcaccess.googleapis.com",
    "sqladmin.googleapis.com",
    "redis.googleapis.com",
  ]
}

resource "google_project_service" "apis" {
  for_each = toset(local.required_apis)

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

# Owns the shared VPC network/subnet/connector. App repos (terraform.twenty,
# terraform.outline, ...) all point at this same `name` with create = false to read
# it back instead of creating their own.
module "network" {
  source = "git::https://github.com/its-me/terraform.module.network.git?ref=v0.1.1"

  project_id = var.project_id
  region     = var.region
  name       = var.network_name
  create     = true

  depends_on = [google_project_service.apis]
}
