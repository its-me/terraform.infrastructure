# Owns the shared Cloud SQL instance. App repos point at this same `name` with
# create = false to read it back, each managing its own database/user on top.
module "postgresql" {
  source = "git::https://github.com/its-me/terraform.module.postgresql.git?ref=v0.1.8"
  count  = local.deployment.create_postgresql ? 1 : 0

  project_id        = var.project_id
  region            = var.region
  name              = local.deployment.postgresql_instance_name
  create            = true
  network_id        = module.network.network_id
  database_version  = local.deployment.postgresql_version
  port              = local.deployment.postgresql_port
  tier              = local.deployment.postgresql_tier
  availability_type = local.deployment.postgresql_availability_type
  disk_size_gb      = local.deployment.postgresql_disk_size_gb
  max_connections   = local.deployment.postgresql_max_connections
  labels            = var.labels

  depends_on = [module.network]
}

moved {
  from = module.postgresql
  to   = module.postgresql[0]
}
