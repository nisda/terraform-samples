output "rest_api_invoke_url" {
  value = {
    dev_stage = aws_api_gateway_stage.sample_api_dev_stage.invoke_url
  }
}