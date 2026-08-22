variable "project_id" {
  description = "GCP project ID to deploy shared infrastructure into."
  type        = string
}

variable "region" {
  description = "GCP region for all resources."
  type        = string
}

variable "network_name" {
  description = "Name for the shared VPC network/subnet/connector (see terraform.module.network). App repos must use the same value."
  type        = string
  default     = "tools"
}

variable "db_instance_name" {
  description = "Name for the shared Cloud SQL instance (see terraform.module.postgresql). App repos must use the same value."
  type        = string
  default     = "postgres"
}

variable "db_tier" {
  description = "Cloud SQL machine tier for the shared Postgres instance."
  type        = string
  default     = "db-f1-micro"
}

variable "db_availability_type" {
  description = "Cloud SQL availability type: ZONAL or REGIONAL (REGIONAL = HA, higher cost)."
  type        = string
  default     = "ZONAL"
}

variable "db_disk_size_gb" {
  description = "Cloud SQL disk size in GB."
  type        = number
  default     = 10
}

variable "redis_instance_name" {
  description = "Name for the shared Memorystore Redis instance (see terraform.module.redis). App repos must use the same value."
  type        = string
  default     = "redis"
}

variable "redis_tier" {
  description = "Memorystore Redis service tier: BASIC (single node) or STANDARD_HA (replica + failover)."
  type        = string
  default     = "BASIC"
}

variable "redis_memory_size_gb" {
  description = "Memorystore Redis instance memory size in GB."
  type        = number
  default     = 1
}

variable "loadbalancer_name" {
  description = "Name prefix for the shared load balancer's resources (see terraform.module.loadbalancer)."
  type        = string
  default     = "apps"
}

variable "backends" {
  description = "Map of domain -> Cloud Run service to route to on the shared load balancer, keyed by the public hostname (e.g. \"crm.example.com\"). One entry per app repo sharing this load balancer."
  type = map(object({
    cloud_run_service = string
    region            = string
  }))
}

variable "labels" {
  description = "Labels applied to all resources that support them."
  type        = map(string)
  default = {
    app        = "infrastructure"
    managed-by = "terraform"
  }
}
