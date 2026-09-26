locals {
  required_apis = compact([
    "compute.googleapis.com",
    local.deployment.create_private_service_access ? "servicenetworking.googleapis.com" : "",
    local.deployment.create_vpc_connector ? "vpcaccess.googleapis.com" : "",
    local.deployment.create_postgresql ? "sqladmin.googleapis.com" : "",
    local.deployment.create_redis ? "redis.googleapis.com" : "",
    length(local.deployment.compute_instances) > 0 ? "iap.googleapis.com" : "",
  ])
}

resource "google_project_service" "apis" {
  for_each = toset(local.required_apis)

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}
