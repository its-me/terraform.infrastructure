# Compute Engine instances on the shared subnet, one per local.deployment.compute_instances
# entry. Public ones get static IPv4 + IPv6 addresses and open 80/443, serving traffic
# directly rather than through the load balancer (TLS terminates on the VM). SSH works
# via IAP:
#   gcloud compute ssh <name> --zone <zone> --tunnel-through-iap
# or, with ssh_source_ranges + ssh_keys set, directly with your own key:
#   ssh -i ~/.ssh/<key> <user>@<external ip>
module "vm" {
  source   = "git::https://github.com/its-me/terraform.module.vm.git?ref=v0.5.0"
  for_each = local.deployment.compute_instances

  project_id   = var.project_id
  zone         = "${var.region}-a"
  name         = each.key
  subnet_id    = module.network.subnet_id
  machine_type = each.value.machine_type

  static_external_ip = each.value.public
  external_ipv6      = each.value.ipv6
  allow_http_https   = each.value.public
  ssh_source_ranges  = each.value.ssh_source_ranges
  ssh_keys           = each.value.ssh_keys
  labels             = var.labels

  depends_on = [google_project_service.apis]
}
