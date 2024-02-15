# locals
locals {
  region = var.region
  prefix = var.base_prefix

  lambda_function_src_dir = "${path.root}/${path.module}/lambda-functions/src"
  lambda_function_tmp_dir = "${path.root}/${path.module}/lambda-functions/.tmp"

  lambda_log_retention_in_days = 7
  lambda_layer_secret_by_region = {
    "ap-northeast-1" = "arn:aws:lambda:ap-northeast-1:133490724326:layer:AWS-Parameters-and-Secrets-Lambda-Extension:11"
  }
  lambda_layer_secret = local.lambda_layer_secret_by_region[local.region]
  lambda_log_level    = "DEBUG"

}