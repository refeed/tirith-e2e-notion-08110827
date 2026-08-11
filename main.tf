# A tiny, credential-free terraform project. `null_resource` needs no cloud account, so
# `terraform plan` runs anywhere -- which is what lets the plan-file case be genuine rather than
# a pre-baked JSON file.
terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
  }
}

variable "db_password" {
  description = "Present to prove masking: this value must never reach the platform."
  type        = string
  sensitive   = true
  default     = "hunter2-plan-secret"
}

resource "null_resource" "app" {
  triggers = {
    instance_type = "m5.24xlarge" # trips no-huge-instances, so the gate has something to catch
    password      = var.db_password
  }
}
