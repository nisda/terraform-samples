# use environment-variables or default-profile
provider "aws" {
  region = var.region
  default_tags {
    tags = {
      ManagedBy       = "Terraform"
      Owner           = var.owner
      Project         = var.project_name
      EnvironmentName = var.environment_name
    }
  }
}


# # use secret-key
# provider "aws" {
#   region     = var.region
#   access_key = "my-access-key"
#   secret_key = "my-secret-key"
#   default_tags {
#     tags = {
#       ManagedBy       = "Terraform"
#       Owner           = var.owner
#       Project         = var.project_name
#       EnvironmentName = var.environment_name
#     }
#   }
# }


# # use credentials-file
# provider "aws" {
#   region                  = var.region
#   shared_credentials_file = "~/.aws/credentials"
#   profile                 = "profile-name"
#   default_tags {
#     tags = {
#       ManagedBy       = "Terraform"
#       Owner           = var.owner
#       Project         = var.project_name
#       EnvironmentName = var.environment_name
#     }
#   }
# }


# # use assume-role
# provider "aws" {
#   region = var.region
#   assume_role {
#     role_arn     = "arn:aws:iam::ACCOUNT_ID:role/ROLE_NAME"
#     session_name = "SESSION_NAME"
#     external_id  = "EXTERNAL_ID"
#   }
#   default_tags {
#     tags = {
#       ManagedBy       = "Terraform"
#       Owner           = var.owner
#       Project         = var.project_name
#       EnvironmentName = var.environment_name
#     }
#   }
# }
