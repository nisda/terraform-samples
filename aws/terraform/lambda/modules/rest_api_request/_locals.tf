# locals
locals {
  prefix = var.base_prefix

  lambda_log_retention_in_days = 7
  lambda_function_src_dir      = "${path.root}/${path.module}/lambda-functions/src"
  lambda_function_tmp_dir      = "${path.root}/${path.module}/lambda-functions/.tmp"
  lambda_layer_src_dir         = "${path.root}/${path.module}/lambda-layers/src"
  lambda_layer_tmp_dir         = "${path.root}/${path.module}/lambda-layers/.tmp"
}