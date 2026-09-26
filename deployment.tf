# One config, several independent parts (e.g. tools, wheelers, landing). The selected
# workspace picks its entry from var.deployments and keeps its own state:
#   terraform workspace select <name> && terraform apply
locals {
  deployment   = var.deployments[terraform.workspace]
  network_name = coalesce(local.deployment.network_name, terraform.workspace)
}

check "private_service_access" {
  assert {
    condition     = local.deployment.create_private_service_access || !(local.deployment.create_postgresql || local.deployment.create_redis)
    error_message = "create_postgresql and create_redis need create_private_service_access = true."
  }
}
