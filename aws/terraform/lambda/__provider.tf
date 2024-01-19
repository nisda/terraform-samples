# use environment-variables or default-profile
provider "aws" {
  region = local.region
  # access_key = "my-access-key"
  # secret_key = "my-secret-key"
  # shared_credentials_file = "~/.aws/credentials"
  # profile                 = "profile-name"
  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Project   = local.project_name
      Env       = local.env
    }
  }
}

