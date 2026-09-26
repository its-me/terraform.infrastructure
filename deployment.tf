# One config, several independent parts (tools, wheelers, landing), each with its own
# tfvars file and its own workspace state:
#   terraform workspace select <deployment>
#   terraform apply -var-file=<deployment>.tfvars
# Applying a tfvars file in the wrong workspace would plan to replace that part's
# resources with another part's, so fail fast instead.
resource "terraform_data" "workspace_guard" {
  lifecycle {
    precondition {
      condition     = terraform.workspace == var.deployment
      error_message = "Workspace \"${terraform.workspace}\" does not match deployment \"${var.deployment}\". Run: terraform workspace select ${var.deployment}"
    }
  }
}

check "private_service_access" {
  assert {
    condition     = var.create_private_service_access || !(var.create_postgresql || var.create_redis)
    error_message = "create_postgresql and create_redis need create_private_service_access = true."
  }
}
