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
