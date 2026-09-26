output "network_id" {
  description = "ID of the shared VPC network."
  value       = module.network.network_id
}

output "network_name" {
  description = "Name of the shared VPC network."
  value       = module.network.network_name
}

output "subnet_id" {
  description = "ID of the shared subnet."
  value       = module.network.subnet_id
}

output "vpc_connector_id" {
  description = "ID of the shared Serverless VPC Access connector. Null if create_vpc_connector = false."
  value       = module.network.vpc_connector_id
}

output "postgresql_instance_name" {
  description = "Name of the shared Cloud SQL instance. Null if create_postgresql = false."
  value       = one(module.postgresql[*].instance_name)
}

output "postgresql_private_ip" {
  description = "Private IP address of the Cloud SQL instance."
  value       = one(module.postgresql[*].instance_private_ip)
}

output "postgresql_port" {
  description = "Port the Cloud SQL Postgres instance listens on."
  value       = one(module.postgresql[*].port)
}

output "postgresql_instance_connection_name" {
  description = "Cloud SQL instance connection name."
  value       = one(module.postgresql[*].instance_connection_name)
}

output "redis_instance_name" {
  description = "Name of the shared Redis instance. Null if create_redis = false."
  value       = one(module.redis[*].instance_name)
}

output "redis_host" {
  description = "Private IP address of the Redis instance."
  value       = one(module.redis[*].host)
}

output "redis_port" {
  description = "Port the Redis instance listens on."
  value       = one(module.redis[*].port)
}

output "compute_instance_zones" {
  description = "Map of Compute Engine instance name -> zone."
  value       = { for name, vm in module.vm : name => vm.zone }
}

output "compute_instance_internal_ips" {
  description = "Map of Compute Engine instance name -> internal IPv4 address."
  value       = { for name, vm in module.vm : name => vm.internal_ip }
}

output "loadbalancer_name" {
  description = "Name prefix of the shared load balancer's resources. Null if local.deployment.backends is empty."
  value       = length(local.deployment.backends) > 0 ? local.deployment.loadbalancer_name : null
}

output "load_balancer_ip" {
  description = "Global external IPv4 address of the shared load balancer (null if local.deployment.backends is empty). Point an A record for every domain in local.deployment.backends at this."
  value       = one(module.loadbalancer[*].ip_address)
}

output "load_balancer_ipv6" {
  description = "Global external IPv6 address of the shared load balancer. Point an AAAA record for every domain in local.deployment.backends at this."
  value       = one(module.loadbalancer[*].ipv6_address)
}

output "dns_zone_names" {
  description = "Cloud DNS managed zone names in use, one per distinct zone_name in local.deployment.backends."
  value       = { for zone, m in module.dns : zone => m.zone_name }
}

output "dns_name_servers" {
  description = "Name servers per DNS zone. Only relevant for a zone that was just created and whose registrar's NS records still need pointing here."
  value       = { for zone, m in module.dns : zone => m.name_servers }
}
