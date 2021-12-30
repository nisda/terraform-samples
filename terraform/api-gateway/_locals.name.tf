locals {
  name = {
    sample_rest_api             = "${var.prefix}-rest-api"
    sample_lambda_function      = "${var.prefix}-event-dump"
    sample_lambda_function_role = "${var.prefix}-event-dump-lambda-role"
  }
}