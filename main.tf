# A plan that infracost can actually price.
#
# `null_resource` costs nothing, so an infracost policy evaluated against it compares 0 against its
# threshold and passes for the wrong reason -- it proves routing, not pricing. A t3.micro has a real
# published monthly cost, so `totalMonthlyCost` comes back non-zero and the cost policy is doing
# arithmetic on a real number.
#
# No AWS credentials are needed: the skip_* flags let `terraform plan` run entirely offline, and
# infracost prices from the plan JSON rather than from the account.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

variable "db_password" {
  description = "Present to prove masking: this value must never reach the platform inside a document."
  type        = string
  sensitive   = true
  default     = "hunter2-plan-secret"
}

resource "aws_instance" "app" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"

  tags = {
    Name     = "tirith-e2e"
    Password = var.db_password
  }
}

resource "aws_db_instance" "db" {
  identifier          = "tirith-e2e-db"
  engine              = "postgres"
  instance_class      = "db.t3.micro"
  allocated_storage   = 20
  username            = "postgres"
  password            = var.db_password
  skip_final_snapshot = true
}
