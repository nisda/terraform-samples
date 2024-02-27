#------------------------------------------------------
# custom-authorizer lambda-invoke-role
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

resource "aws_iam_role_policy" "apigw_authorizer_invoke_role_lambda_policy" {
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

#------------------------------------------------------
# custom-authorizer: lambda-role
#------------------------------------------------------
resource "aws_iam_role" "apigw_authorizer_lambda_role" {
  name = "${local.prefix}-apigw-authorizer-lambda-role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
          "Effect" : "Allow",
          "Sid" : ""
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "apigw_authorizer_lambda_role_basic_policy" {
  role       = aws_iam_role.apigw_authorizer_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_iam_role_policy" "apigw_authorizer_lambda_role_dynamodb_policy" {
  role = aws_iam_role.apigw_authorizer_lambda_role.name
  name = "dynamodb-read"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:GetItem",
            "dynamodb:BatchGetItem",
            "dynamodb:Query",
            "dynamodb:Scan",
          ]
          "Resource" : aws_dynamodb_table.apigw_basic_auth_table.arn,
        }
      ]
    }
  )
}
