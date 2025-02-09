# 平文
resource "aws_ssm_parameter" "plain_text" {
  name = "/${local.prefix}/plain-text"
  tags = {
    Name = "/${local.prefix}/plain-text"
  }
  type  = "String"
  value = "<dummy-plain-value>"
  lifecycle {
    ignore_changes = [value]
  }
}

# KMSによる暗号化
resource "aws_ssm_parameter" "secret_text" {
  name = "/${local.prefix}/secret-text"
  tags = {
    Name = "/${local.prefix}/secret-text"
  }
  type  = "SecureString"
  value = "<dummy-secret-value>"
  lifecycle {
    ignore_changes = [value]
  }
}
