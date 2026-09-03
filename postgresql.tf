# Owns the shared Cloud SQL instance. App repos point at this same `name` with
# create = false to read it back, each managing its own database/user on top.
module "postgresql" {
  source = "git::https://github.com/its-me/terraform.module.postgresql.git?ref=v0.1.5"

  project_id        = var.project_id
  region            = var.region
  name              = var.db_instance_name
  create            = true
  network_id        = module.network.network_id
  database_version  = var.db_version
  tier              = var.db_tier
  availability_type = var.db_availability_type
  disk_size_gb      = var.db_disk_size_gb
  labels            = var.labels

  depends_on = [module.network]
}
