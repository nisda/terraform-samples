data "aws_caller_identity" "current" {}

data "aws_arn" "root" {
  arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
}
