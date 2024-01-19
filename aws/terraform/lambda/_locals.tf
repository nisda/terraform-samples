
# locals
locals {
  region       = "ap-northeast-1"
  project_name = "Lambda-PoC"
  env          = "poc"
  prefix       = "lambda-${local.env}"
}