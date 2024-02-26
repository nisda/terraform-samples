//---------------------------------------
//  イベント情報をDUMP出力
//---------------------------------------
data "archive_file" "sqs_trigger_lambda" {
  type             = "zip"
  source_dir       = "${local.lambda_function_src_dir}/sqs_trigger"
  output_path      = "${local.lambda_function_tmp_dir}/sqs_trigger.zip"
  output_file_mode = "0644"
}

resource "aws_lambda_function" "sqs_trigger_lambda" {
  function_name = "${local.prefix}-sqs-trigger"
  tags = {
    Name = "${local.prefix}-sqs-trigger"
  }
  role             = aws_iam_role.sqs_trigger_lambda_role.arn
  filename         = data.archive_file.sqs_trigger_lambda.output_path
  source_code_hash = data.archive_file.sqs_trigger_lambda.output_base64sha256
  runtime          = "python3.11"
  handler          = "sqs_trigger.lambda_handler"
  memory_size      = 128
  timeout          = 30

  environment {
    variables = {
    }
  }

  layers = [
  ]

  lifecycle {
    ignore_changes = [
      filename
    ]
  }

}

resource "aws_cloudwatch_log_group" "sqs_trigger_lambda" {
  name = "/aws/lambda/${aws_lambda_function.sqs_trigger_lambda.function_name}"
  tags = {
    Name = "${aws_lambda_function.sqs_trigger_lambda.function_name}-log"
  }
  retention_in_days = local.lambda_log_retention_in_days
}

