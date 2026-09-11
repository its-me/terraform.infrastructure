# Points every domain in var.backends at the shared load balancer. Domains can belong
# to different Cloud DNS zones (one module.dns instance per distinct zone_name); each
# instance only manages the record sets for domains in its own zone.
locals {
  domains_by_zone = {
    for zone in distinct([for b in var.backends : b.zone_name]) :
    zone => [for domain, b in var.backends : domain if b.zone_name == zone]
  }
}

module "dns" {
  source   = "git::https://github.com/its-me/terraform.module.dns.git?ref=v0.1.0"
  for_each = local.domains_by_zone

  project_id = var.project_id
  zone_name  = each.key
  records = merge(
    { for domain in each.value : "${replace(domain, ".", "-")}-a" => {
      name    = domain
      type    = "A"
      rrdatas = [module.loadbalancer.ip_address]
    } },
    { for domain in each.value : "${replace(domain, ".", "-")}-aaaa" => {
      name    = domain
      type    = "AAAA"
      rrdatas = [module.loadbalancer.ipv6_address]
    } },
  )

  depends_on = [module.loadbalancer]
}
