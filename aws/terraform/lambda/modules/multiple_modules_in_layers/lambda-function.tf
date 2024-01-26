//---------------------------------------
//  APIリクエスト
//---------------------------------------
data "archive_file" "multiple_modules_function" {
  type        = "zip"
  source_dir  = "${local.lambda_function_src_dir}/multiple_modules_in_layers"
  output_path = "${local.lambda_function_tmp_dir}/multiple_modules_in_layers.zip"
}

resource "aws_lambda_function" "multiple_modules_function" {
  function_name = "${local.prefix}-multiple-modules-in-layers"
  tags = {
    Name = "${local.prefix}-multiple-modules-in-layers"
  }
  role             = aws_iam_role.multiple_modules_lambda_role.arn
  filename         = data.archive_file.multiple_modules_function.output_path
  source_code_hash = data.archive_file.multiple_modules_function.output_base64sha256
  runtime          = "python3.11"
  handler          = "multiple_modules_in_layer.lambda_handler"
  memory_size      = 128
  timeout          = 30

  environment {
    variables = {
    }
  }

  layers = [
    aws_lambda_layer_version.multiple_modules_lambda_layer.arn
  ]

  lifecycle {
    ignore_changes = [
      filename
    ]
  }

}

resource "aws_cloudwatch_log_group" "multiple_modules_function" {
  name = "/aws/lambda/${aws_lambda_function.multiple_modules_function.function_name}"
  tags = {
    Name = "${aws_lambda_function.multiple_modules_function.function_name}-log"
  }
  retention_in_days = local.lambda_log_retention_in_days
}

