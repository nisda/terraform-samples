//---------------------------------------
//  スケルトン
//---------------------------------------
data "archive_file" "template_function" {
  type             = "zip"
  source_dir       = "${local.lambda_func_base_dir}/lambda-template/src"
  output_path      = "${local.lambda_func_base_dir}/lambda-template/.tmp/lambda_function.zip"
  output_file_mode = "0644"
  excludes = [
    "**/__pycache__/*",
    "**/.pytest_cache/*",
  ]
}

resource "aws_lambda_function" "template_function" {
  function_name = "${local.prefix}-template-function"
  tags = {
    Name = "${local.prefix}-template-function"
  }
  role             = aws_iam_role.lambda_common_role.arn
  filename         = data.archive_file.template_function.output_path
  source_code_hash = data.archive_file.template_function.output_base64sha256
  runtime          = local.lambda_runtime_version
  handler          = "lambda_handler.lambda_handler"
  memory_size      = 128
  timeout          = 30

  environment {
    variables = {
      POWERTOOLS_SERVICE_NAME = "template-function"
      LOG_LEVEL               = local.lambda_log_level
      TZ                      = local.lambda_tz
      PS_PLAIN_TEXT           = aws_ssm_parameter.plain_text.name
      PS_SECRET_TEXT          = aws_ssm_parameter.secret_text.name
    }
  }

  layers = [
    # local.lambda_layer_secret,
    local.lambda_layer_arn["LambdaPowertools"]
  ]

  lifecycle {
    ignore_changes = [
      filename,
      environment.0.variables["LOG_LEVEL"],
    ]
  }

}

resource "aws_cloudwatch_log_group" "template_function" {
  name = "/aws/lambda/${aws_lambda_function.template_function.function_name}"
  tags = {
    Name = "${aws_lambda_function.template_function.function_name}-log"
  }
  retention_in_days = local.lambda_log_retention_in_days
}
