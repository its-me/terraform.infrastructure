# Compute Engine instances on the shared subnet, one per var.compute_instances entry.
# No public IPs; reachable over SSH via IAP only:
#   gcloud compute ssh <name> --zone <zone> --tunnel-through-iap
module "vm" {
  source   = "git::https://github.com/its-me/terraform.module.vm.git?ref=v0.1.0"
  for_each = var.compute_instances

  project_id   = var.project_id
  zone         = "${var.region}-a"
  name         = each.key
  subnet_id    = module.network.subnet_id
  machine_type = each.value.machine_type
  labels       = var.labels

  depends_on = [google_project_service.apis]
}
