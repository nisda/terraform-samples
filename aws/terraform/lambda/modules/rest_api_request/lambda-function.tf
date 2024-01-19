//---------------------------------------
//  APIリクエスト
//---------------------------------------
data "archive_file" "rest_api_request_function" {
  type        = "zip"
  source_dir  = "${local.lambda_function_src_dir}/rest_api_request"
  output_path = "${local.lambda_function_tmp_dir}/rest_api_request.zip"
}

resource "aws_lambda_function" "rest_api_request_function" {
  function_name = "${local.prefix}-rest-api-request"
  tags = {
    Name = "${local.prefix}-rest-api-request"
  }
  role             = aws_iam_role.rest_api_reqest_lambda_role.arn
  filename         = data.archive_file.rest_api_request_function.output_path
  source_code_hash = data.archive_file.rest_api_request_function.output_base64sha256
  runtime          = "python3.11"
  handler          = "rest_api_request.lambda_handler"
  memory_size      = 128
  timeout          = 30

  environment {
    variables = {
    }
  }

  layers = [
    aws_lambda_layer_version.rest_api_lambda.arn
  ]

  lifecycle {
    ignore_changes = [
      filename
    ]
  }

}

resource "aws_cloudwatch_log_group" "rest_api_request_function" {
  name = "/aws/lambda/${aws_lambda_function.rest_api_request_function.function_name}"
  tags = {
    Name = "${aws_lambda_function.rest_api_request_function.function_name}-log"
  }
  retention_in_days = local.lambda_log_retention_in_days
}

