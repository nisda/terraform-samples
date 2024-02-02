provider "aws" {
  region = local.region
  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Project   = local.project_name
      Env       = local.env
    }
  }
}
