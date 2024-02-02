resource "aws_api_gateway_api_key" "sample_api_key" {
  name    = "${local.prefix}-sample-api-key"
  enabled = true
}

resource "aws_api_gateway_usage_plan" "sample_plan" {
  name = "${local.prefix}-sample-plan"
  api_stages {
    api_id = aws_api_gateway_rest_api.sample_rest_api.id
    stage  = aws_api_gateway_stage.sample_api_dev_stage.stage_name
  }
}

resource "aws_api_gateway_usage_plan_key" "sample_plan_key" {
  key_id        = aws_api_gateway_api_key.sample_api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.sample_plan.id
}
