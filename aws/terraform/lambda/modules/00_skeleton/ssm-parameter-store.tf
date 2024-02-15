# 平文
resource "aws_ssm_parameter" "plain" {
  name = "/${local.prefix}/plain"
  tags = {
    Name = "/${local.prefix}/plain"
  }
  type  = "String"
  value = "<dummy-plain-value>"
  lifecycle {
    ignore_changes = [value]
  }
}

# KMSによる暗号化
resource "aws_ssm_parameter" "secret" {
  name = "/${local.prefix}/secret"
  tags = {
    Name = "/${local.prefix}/secret"
  }
  type  = "SecureString"
  value = "<dummy-secret-value>"
  lifecycle {
    ignore_changes = [value]
  }
}
