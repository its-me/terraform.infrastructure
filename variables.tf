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

variable "postgresql_instance_name" {
  description = "Name for the shared Cloud SQL instance (see terraform.module.postgresql). App repos must use the same value."
  type        = string
  default     = "postgresql0"
}

variable "postgresql_port" {
  description = "Port the Cloud SQL Postgres instance listens on. Cloud SQL doesn't expose this as an attribute; fixed at 5432 for Postgres."
  type        = number
  default     = 5432
}

variable "postgresql_version" {
  description = "Postgres version for the shared Cloud SQL instance."
  type        = string
  default     = "POSTGRES_18"
}

variable "postgresql_tier" {
  description = "Cloud SQL machine tier for the shared Postgres instance."
  type        = string
  default     = "db-f1-micro"
}

variable "postgresql_availability_type" {
  description = "Cloud SQL availability type: ZONAL or REGIONAL (REGIONAL = HA, higher cost)."
  type        = string
  default     = "ZONAL"
}

variable "postgresql_disk_size_gb" {
  description = "Cloud SQL disk size in GB."
  type        = number
  default     = 10
}

variable "postgresql_max_connections" {
  description = "Override for the max_connections database flag. Leave null to use Cloud SQL's memory-based default (25 for db-f1-micro). Sized for Twenty (server + worker, 10-connection pool each by default) and Outline (write pool 5 + read-only pool 10, per instance, up to 2 instances) sharing this one instance, plus reserved/internal connections."
  type        = number
  default     = 50
}

variable "redis_instance_name" {
  description = "Name for the shared Memorystore Redis instance (see terraform.module.redis). App repos must use the same value."
  type        = string
  default     = "redis0"
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
  default     = "tools"
}

variable "backends" {
  description = "Map of domain -> backend to route to on the shared load balancer, keyed by the public hostname (e.g. \"crm.example.com\"). One entry per app repo sharing this load balancer. zone_name is the Cloud DNS managed zone (resource name, not DNS suffix) that domain belongs to -- domains on different zones are fine, one google_dns_managed_zone lookup happens per distinct zone_name. Each entry needs either cloud_run_service + region (this repo creates the NEG + backend service, e.g. twenty/outline), or backend_service_id (an already-created backend service owned by the app's own repo/state, e.g. landing) -- see terraform.module.loadbalancer's backends variable."
  type = map(object({
    cloud_run_service  = optional(string)
    region             = optional(string)
    backend_service_id = optional(string)
    zone_name          = string
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
