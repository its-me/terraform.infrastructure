# Compute Engine instances on the shared subnet, one per local.deployment.compute_instances
# entry. Public ones get a static IP and open 80/443, serving traffic directly rather
# than through the load balancer (TLS terminates on the VM). SSH is via IAP only:
#   gcloud compute ssh <name> --zone <zone> --tunnel-through-iap
module "vm" {
  source   = "git::https://github.com/its-me/terraform.module.vm.git?ref=v0.2.0"
  for_each = local.deployment.compute_instances

  project_id   = var.project_id
  zone         = "${var.region}-a"
  name         = each.key
  subnet_id    = module.network.subnet_id
  machine_type = each.value.machine_type

  static_external_ip = each.value.public
  allow_http_https   = each.value.public
  labels             = var.labels

  depends_on = [google_project_service.apis]
}
