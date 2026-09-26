# Initial Compute Engine instance on the shared subnet, sized at the smallest
# available footprint. Reachable over SSH via IAP only (no public IP):
#   gcloud compute ssh <name> --zone <zone> --tunnel-through-iap
module "vm" {
  source = "git::https://github.com/its-me/terraform.module.vm.git?ref=v0.1.0"

  project_id   = var.project_id
  zone         = "${var.region}-a"
  name         = var.compute_instance_name
  subnet_id    = module.network.subnet_id
  machine_type = var.compute_machine_type
  labels       = var.labels

  depends_on = [google_project_service.apis]
}
