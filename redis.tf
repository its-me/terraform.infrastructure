# Owns the shared Memorystore Redis instance. App repos point at this same `name`
# with create = false to read it back, each isolating its keys via its own Redis
# DB index.
module "redis" {
  source = "git::https://github.com/its-me/terraform.module.redis.git?ref=v0.1.0"

  project_id = var.project_id
  region     = var.region
  name       = var.redis_instance_name
  create     = true
  network_id = module.network.network_id

  tier           = var.redis_tier
  memory_size_gb = var.redis_memory_size_gb
  labels         = var.labels

  depends_on = [module.network]
}
