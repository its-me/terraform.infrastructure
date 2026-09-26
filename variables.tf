variable "project_id" {
  description = "GCP project ID to deploy into. Shared by every deployment."
  type        = string
}

variable "region" {
  description = "GCP region for all resources. Shared by every deployment."
  type        = string
}

variable "deployments" {
  description = <<-EOT
    Independent parts of the infrastructure, keyed by Terraform workspace name. The
    selected workspace picks its entry, and each workspace keeps its own state:
      terraform workspace select <name> && terraform apply

    Every setting is optional; defaults are in parentheses.
    - network_name (the workspace name): VPC network/subnet/connector name, see
      terraform.module.network. App repos must use the same value.
    - create_private_service_access (true): servicenetworking peering. Required by
      create_postgresql and create_redis.
    - create_vpc_connector (true): Serverless VPC Access connector. Runs 2+ VMs at all
      times; only needed when Cloud Run services use this network.
    - create_postgresql (true), create_redis (true): create the Cloud SQL / Memorystore
      Redis instance.
    - postgresql_instance_name ("postgresql0"), postgresql_version ("POSTGRES_18"),
      postgresql_tier ("db-f1-micro"), postgresql_availability_type ("ZONAL";
      REGIONAL = HA, higher cost), postgresql_disk_size_gb (10). App repos must use
      the same instance name.
    - postgresql_port (5432): Cloud SQL doesn't expose this as an attribute; fixed for
      Postgres.
    - postgresql_max_connections (50): max_connections flag override; null uses Cloud
      SQL's memory-based default (25 for db-f1-micro). 50 is sized for Twenty (server
      + worker, 10-connection pool each) and Outline (write pool 5 + read pool 10 per
      instance, up to 2 instances) sharing one instance, plus reserved connections.
    - redis_instance_name ("redis0"), redis_tier ("BASIC"; or STANDARD_HA),
      redis_memory_size_gb (1). App repos must use the same instance name.
    - compute_instances ({}): VMs on this network, keyed by instance name.
      machine_type defaults to e2-micro (2 shared vCPUs, 1 GB), the smallest available.
    - loadbalancer_name ("tools"): name prefix for the load balancer's resources.
    - backends ({}): domain -> backend on the load balancer, keyed by public hostname.
      The load balancer and DNS records are only created when this is non-empty.
      zone_name is the existing Cloud DNS managed zone (resource name) the domain
      belongs to. Each entry needs either cloud_run_service + region (this repo creates
      the NEG + backend service) or backend_service_id (a backend service owned by the
      app's own repo) -- see terraform.module.loadbalancer.
  EOT
  type = map(object({
    network_name                  = optional(string)
    create_private_service_access = optional(bool, true)
    create_vpc_connector          = optional(bool, true)
    create_postgresql             = optional(bool, true)
    create_redis                  = optional(bool, true)

    postgresql_instance_name     = optional(string, "postgresql0")
    postgresql_port              = optional(number, 5432)
    postgresql_version           = optional(string, "POSTGRES_18")
    postgresql_tier              = optional(string, "db-f1-micro")
    postgresql_availability_type = optional(string, "ZONAL")
    postgresql_disk_size_gb      = optional(number, 10)
    postgresql_max_connections   = optional(number, 50)

    redis_instance_name  = optional(string, "redis0")
    redis_tier           = optional(string, "BASIC")
    redis_memory_size_gb = optional(number, 1)

    compute_instances = optional(map(object({
      machine_type = optional(string, "e2-micro")
    })), {})

    loadbalancer_name = optional(string, "tools")
    backends = optional(map(object({
      cloud_run_service  = optional(string)
      region             = optional(string)
      backend_service_id = optional(string)
      zone_name          = string
    })), {})
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
