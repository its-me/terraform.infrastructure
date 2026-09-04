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
  description = "ID of the shared Serverless VPC Access connector."
  value       = module.network.vpc_connector_id
}

output "postgresql_instance_name" {
  description = "Name of the shared Cloud SQL instance."
  value       = module.postgresql.instance_name
}

output "postgresql_private_ip" {
  description = "Private IP address of the Cloud SQL instance."
  value       = module.postgresql.instance_private_ip
}

output "postgresql_port" {
  description = "Port the Cloud SQL Postgres instance listens on."
  value       = module.postgresql.port
}

output "postgresql_instance_connection_name" {
  description = "Cloud SQL instance connection name."
  value       = module.postgresql.instance_connection_name
}

output "redis_instance_name" {
  description = "Name of the shared Redis instance."
  value       = module.redis.instance_name
}

output "redis_host" {
  description = "Private IP address of the Redis instance."
  value       = module.redis.host
}

output "redis_port" {
  description = "Port the Redis instance listens on."
  value       = module.redis.port
}

output "loadbalancer_name" {
  description = "Name prefix of the shared load balancer's resources."
  value       = var.loadbalancer_name
}

output "load_balancer_ip" {
  description = "Global external IPv4 address of the shared load balancer. Point an A record for every domain in var.backends at this."
  value       = module.loadbalancer.ip_address
}

output "load_balancer_ipv6" {
  description = "Global external IPv6 address of the shared load balancer. Point an AAAA record for every domain in var.backends at this."
  value       = module.loadbalancer.ipv6_address
}

output "dns_zone_name" {
  description = "Name of the Cloud DNS managed zone every domain in var.backends is in."
  value       = module.dns.zone_name
}

output "dns_name_servers" {
  description = "Name servers for the DNS zone. Only relevant if the zone was just created and its registrar's NS records still need pointing here."
  value       = module.dns.name_servers
}
