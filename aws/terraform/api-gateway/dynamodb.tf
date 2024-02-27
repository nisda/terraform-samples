resource "aws_dynamodb_table" "apigw_basic_auth_table" {
  name = "${local.prefix}-apigw-basic-auth"
  tags = {
    Name = "${local.prefix}-apigw-basic-auth"
  }
  billing_mode = "PAY_PER_REQUEST"

  # userid(pk), password, [additional_infos...]
  hash_key = "user_id"
  attribute {
    name = "user_id"
    type = "S"
  }
}