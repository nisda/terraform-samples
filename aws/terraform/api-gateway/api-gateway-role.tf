#------------------------------------------------------
# custom-authorizer-lambda invoke-role
#------------------------------------------------------
resource "aws_iam_role" "apigw_authorizer_invoke_role" {
  name = "${local.prefix}-apigw-authorizer-invoke-role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "apigateway.amazonaws.com"
          },
          "Effect" : "Allow",
          "Sid" : ""
        }
      ]
    }
  )
}

resource "aws_iam_role_policy" "apigw_authorizer_invoke_role_policy" {
  role = aws_iam_role.apigw_authorizer_invoke_role.name
  name = "invoke-authorizer-lambda"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "lambda:InvokeFunction",
          "Resource" : "*",
        }
      ]
    }
  )
}
