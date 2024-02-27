#------------------------------------------------------
# Lambda Function: イベント出力
#------------------------------------------------------

data "archive_file" "event_dump_lambda_zip" {
  type             = "zip"
  source_dir       = "${local.lambda_func_src_dir}/event_dump"
  output_path      = "${local.lambda_func_tmp_dir}/event_dump.zip"
  output_file_mode = "644"
}

resource "aws_lambda_function" "event_dump_lambda" {
  function_name    = "${local.prefix}-event-dump"
  role             = aws_iam_role.lambda_common_role.arn
  filename         = data.archive_file.event_dump_lambda_zip.output_path
  source_code_hash = data.archive_file.event_dump_lambda_zip.output_base64sha256
  runtime          = "python3.9"
  handler          = "event_dump.lambda_handler"
  memory_size      = 128
  timeout          = 10
  lifecycle {
    ignore_changes = [filename]
  }
}

resource "aws_cloudwatch_log_group" "event_dump_lambda_log" {
  name = "/aws/lambda/${aws_lambda_function.event_dump_lambda.function_name}"
  tags = {
    Name = "${aws_lambda_function.event_dump_lambda.function_name}-log"
  }
  retention_in_days = local.lambda_log_retention_in_days
}

#------------------------------------------------------
# API-Gateway向けリソースベースポリシー
#------------------------------------------------------
resource "aws_lambda_permission" "event_dump_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.event_dump_lambda.function_name
  source_arn    = "${aws_api_gateway_rest_api.sample_rest_api.execution_arn}/*/*/*" # <execution_arn>/<stage>/<method>/<path>
}

