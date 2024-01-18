data "archive_file" "sample_lambda_function_zip" {
  type        = "zip"
  source_file = "./lambda-function/apigw_event_dump.py"
  output_path = "/tmp/lambda-function/apigw_event_dump.zip"
}

resource "aws_lambda_function" "sample_lambda_function" {
  function_name    = local.name.sample_lambda_function
  role             = aws_iam_role.sample_lambda_function_role.arn
  filename         = data.archive_file.sample_lambda_function_zip.output_path
  source_code_hash = data.archive_file.sample_lambda_function_zip.output_base64sha256
  runtime          = "python3.9"
  handler          = "apigw_event_dump.lambda_handler"
  memory_size      = 128
  timeout          = 10
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.sample_lambda_function.function_name
  source_arn    = "${aws_api_gateway_rest_api.sample_rest_api.execution_arn}/*/*/*" # <execution_arn>/<stage>/<method>/<path>
}
