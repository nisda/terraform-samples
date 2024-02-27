
#------------------------------------------------------
# Lambda Function：API-Gateway Basic認証
#------------------------------------------------------

data "archive_file" "apigw_basic_authorizer_lambda_zip" {
  type             = "zip"
  source_dir       = "${local.lambda_func_src_dir}/apigw_basic_authorizer"
  output_path      = "${local.lambda_func_tmp_dir}/apigw_basic_authorizer.zip"
  output_file_mode = "644"
}

resource "aws_lambda_function" "apigw_basic_authorizer_lambda" {
  function_name = "${local.prefix}-apigw-basic-authorizer"
  tags = {
    Name = "${local.prefix}-apigw-basic-authorizer"
  }
  role             = aws_iam_role.apigw_authorizer_lambda_role.arn
  filename         = data.archive_file.apigw_basic_authorizer_lambda_zip.output_path
  source_code_hash = data.archive_file.apigw_basic_authorizer_lambda_zip.output_base64sha256
  runtime          = "python3.11"
  handler          = "apigw_basic_authorizer.lambda_handler"
  memory_size      = 128
  timeout          = 10
  environment {
    variables = {
      DYNAMODB_TABLE_BASIC_AUTH = aws_dynamodb_table.apigw_basic_auth_table.name
    }
  }

  lifecycle {
    ignore_changes = [filename]
  }
}

resource "aws_cloudwatch_log_group" "apigw_basic_authorizer_lambda_log" {
  name = "/aws/lambda/${aws_lambda_function.apigw_basic_authorizer_lambda.function_name}"
  tags = {
    Name = "${aws_lambda_function.apigw_basic_authorizer_lambda.function_name}-log"
  }
  retention_in_days = local.lambda_log_retention_in_days
}



#------------------------------------------------------
# Lambda Function：API-Gateway カスタムオーソライザー
#------------------------------------------------------

data "archive_file" "apigw_custom_authorizer_lambda_zip" {
  type             = "zip"
  source_dir       = "${local.lambda_func_src_dir}/apigw_custom_authorizer"
  output_path      = "${local.lambda_func_tmp_dir}/apigw_custom_authorizer.zip"
  output_file_mode = "644"
}

resource "aws_lambda_function" "apigw_custom_authorizer_lambda" {
  function_name = "${local.prefix}-apigw-custom-authorizer"
  tags = {
    Name = "${local.prefix}-apigw-custom-authorizer"
  }
  role             = aws_iam_role.apigw_authorizer_lambda_role.arn
  filename         = data.archive_file.apigw_custom_authorizer_lambda_zip.output_path
  source_code_hash = data.archive_file.apigw_custom_authorizer_lambda_zip.output_base64sha256
  runtime          = "python3.9"
  handler          = "apigw_custom_authorizer.lambda_handler"
  memory_size      = 128
  timeout          = 10
  lifecycle {
    ignore_changes = [filename]
  }
}

resource "aws_cloudwatch_log_group" "apigw_custom_authorizer_lambda_log" {
  name = "/aws/lambda/${aws_lambda_function.apigw_custom_authorizer_lambda.function_name}"
  tags = {
    Name = "${aws_lambda_function.apigw_custom_authorizer_lambda.function_name}-log"
  }
  retention_in_days = local.lambda_log_retention_in_days
}

