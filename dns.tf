# Points every domain in var.backends at the shared load balancer. Assumes all
# backends share one Cloud DNS zone; if that ever stops being true, this needs to
# become a map of domain -> zone_name instead of one var.dns_zone_name for all of them.
locals {
  dns_records = merge(
    { for domain, _ in var.backends : "${replace(domain, ".", "-")}-a" => {
      name    = domain
      type    = "A"
      rrdatas = [module.loadbalancer.ip_address]
    } },
    { for domain, _ in var.backends : "${replace(domain, ".", "-")}-aaaa" => {
      name    = domain
      type    = "AAAA"
      rrdatas = [module.loadbalancer.ipv6_address]
    } },
  )
}

module "dns" {
  source = "git::https://github.com/its-me/terraform.module.dns.git?ref=v0.1.0"

  project_id = var.project_id
  zone_name  = var.dns_zone_name
  records    = local.dns_records

  depends_on = [module.loadbalancer]
}
