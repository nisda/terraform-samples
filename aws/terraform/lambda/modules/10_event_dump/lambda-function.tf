//---------------------------------------
//  イベント情報をDUMP出力
//---------------------------------------
data "archive_file" "event_dump_function" {
  type             = "zip"
  source_dir       = "${local.lambda_function_src_dir}/event_dump"
  output_path      = "${local.lambda_function_tmp_dir}/event_dump.zip"
  output_file_mode = "0644"
}

resource "aws_lambda_function" "event_dump_function" {
  function_name = "${local.prefix}-event-dump"
  tags = {
    Name = "${local.prefix}-event-dump"
  }
  role             = aws_iam_role.event_dump_lambda_role.arn
  filename         = data.archive_file.event_dump_function.output_path
  source_code_hash = data.archive_file.event_dump_function.output_base64sha256
  runtime          = "python3.11"
  handler          = "event_dump.lambda_handler"
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

resource "aws_cloudwatch_log_group" "event_dump_function" {
  name = "/aws/lambda/${aws_lambda_function.event_dump_function.function_name}"
  tags = {
    Name = "${aws_lambda_function.event_dump_function.function_name}-log"
  }
  retention_in_days = local.lambda_log_retention_in_days
}

