data "aws_caller_identity" "main" { provider = aws }

# locals: basic-info
locals {
  region       = "ap-northeast-1"
  project_name = "lambda-template"
  env          = var.env
  prefix       = "lambda-template-${local.env}"
}

# locals: by-resources
locals {
  lambda_func_base_dir         = "${path.root}/${path.module}/lambda-functions/"
  lambda_runtime_version       = "python3.12"
  lambda_log_retention_in_days = var.log_retension_in_days
  lambda_log_level             = "DEBUG"
  lambda_tz                    = "Asia/Tokyo"
  lambda_layer_secret_by_region = {
    "ap-northeast-1" = "arn:aws:lambda:ap-northeast-1:133490724326:layer:AWS-Parameters-and-Secrets-Lambda-Extension:12"
  }
  lambda_layer_secret = local.lambda_layer_secret_by_region[local.region]
  lambda_layer_arn = {
    "ap-northeast-1" = {
      "LambdaPowertools" = "arn:aws:lambda:ap-northeast-1:017000801446:layer:AWSLambdaPowertoolsPythonV3-python312-x86_64:6"
    }
  }[local.region]
}

