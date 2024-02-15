//---------------------------------------
//  スケルトン
//---------------------------------------
data "archive_file" "skeleton_function" {
  type             = "zip"
  source_dir       = "${local.lambda_function_src_dir}/skeleton"
  output_path      = "${local.lambda_function_tmp_dir}/skeleton.zip"
  output_file_mode = "0644"
}

resource "aws_lambda_function" "skeleton_function" {
  function_name = "${local.prefix}-skeleton"
  tags = {
    Name = "${local.prefix}-skeleton"
  }
  role             = aws_iam_role.get_ps_lambda_role.arn
  filename         = data.archive_file.skeleton_function.output_path
  source_code_hash = data.archive_file.skeleton_function.output_base64sha256
  runtime          = "python3.11"
  handler          = "skeleton.lambda_handler"
  memory_size      = 128
  timeout          = 30

  environment {
    variables = {
      LOG_LEVEL            = local.lambda_log_level
      SSM_PLAIN_STRING_PS  = aws_ssm_parameter.plain.name
      SSM_SECRET_STRING_PS = aws_ssm_parameter.secret.name
    }
  }

  layers = [
    local.lambda_layer_secret,
  ]

  lifecycle {
    ignore_changes = [
      filename,
      environment["LOG_LEVEL"],
    ]
  }

}

resource "aws_cloudwatch_log_group" "skeleton_function" {
  name = "/aws/lambda/${aws_lambda_function.skeleton_function.function_name}"
  tags = {
    Name = "${aws_lambda_function.skeleton_function.function_name}-log"
  }
  retention_in_days = local.lambda_log_retention_in_days
}
