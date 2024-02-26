
# locals
locals {
  region       = "ap-northeast-1"
  project_name = "Lambda-Trigger-PoC"
  env          = "poc"
  prefix       = "lambda-trigger-${local.env}"
}

locals {
  lambda_function_src_dir      = "${path.root}/${path.module}/lambda-functions/src"
  lambda_function_tmp_dir      = "${path.root}/${path.module}/lambda-functions/.tmp"
  lambda_log_retention_in_days = 7
}