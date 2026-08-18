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

output "db_instance_connection_name" {
  description = "Cloud SQL instance connection name."
  value       = module.postgresql.instance_connection_name
}

output "db_private_ip" {
  description = "Private IP address of the Cloud SQL instance."
  value       = module.postgresql.instance_private_ip
}

output "redis_host" {
  description = "Private IP address of the Redis instance."
  value       = module.redis.host
}

output "redis_port" {
  description = "Port the Redis instance listens on."
  value       = module.redis.port
}
