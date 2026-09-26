# Owns the shared global external HTTPS load balancer in front of every app's Cloud
# Run service, host-routed by domain. See terraform.module.loadbalancer for why this
# can't follow the network/postgresql/redis create = false pattern: the URL map's host
# rules and the certificate's domain list must be known in full at apply time.
module "loadbalancer" {
  source = "git::https://github.com/its-me/terraform.module.loadbalancer.git?ref=v0.1.2"
  count  = length(local.deployment.backends) > 0 ? 1 : 0

  project_id = var.project_id
  name       = local.deployment.loadbalancer_name
  backends   = local.deployment.backends
}

moved {
  from = module.loadbalancer
  to   = module.loadbalancer[0]
}
