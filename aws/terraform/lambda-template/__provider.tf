terraform {
  required_version = "~> 1.10.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.83.1"
    }
  }
}

provider "aws" {
  region = local.region
  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Project   = local.project_name
      Env       = local.env
    }
  }

  ## aws-credential
  # access_key = "my-access-key"
  # secret_key = "my-secret-key"
  # shared_credentials_file = "~/.aws/credentials"
  profile = "nisda-poc-01"
}

