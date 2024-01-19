//---------------------------------------
//  パラメータストア読み込み
//---------------------------------------
data "archive_file" "get_parameter_store_function" {
  type        = "zip"
  source_dir  = "${local.lambda_function_src_dir}/get_parameter_store"
  output_path = "${local.lambda_function_tmp_dir}/get_parameter_store.zip"
}

resource "aws_lambda_function" "get_parameter_store_function" {
  function_name = "${local.prefix}-get-parameter-store"
  tags = {
    Name = "${local.prefix}-get-parameter-store"
  }
  role             = aws_iam_role.get_ps_lambda_role.arn
  filename         = data.archive_file.get_parameter_store_function.output_path
  source_code_hash = data.archive_file.get_parameter_store_function.output_base64sha256
  runtime          = "python3.11"
  handler          = "get_parameter_store.lambda_handler"
  memory_size      = 128
  timeout          = 30

  environment {
    variables = {
      SSM_PLAIN_STRING_PS  = aws_ssm_parameter.plain.name
      SSM_SECRET_STRING_PS = aws_ssm_parameter.secret.name
    }
  }

  layers = [
    local.lambda_layer_secret,
  ]

  lifecycle {
    ignore_changes = [
      filename
    ]
  }

}

resource "aws_cloudwatch_log_group" "get_parameter_store_function" {
  name = "/aws/lambda/${aws_lambda_function.get_parameter_store_function.function_name}"
  tags = {
    Name = "${aws_lambda_function.get_parameter_store_function.function_name}-log"
  }
  retention_in_days = local.lambda_log_retention_in_days
}
