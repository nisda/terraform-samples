
// for All
resource "aws_iam_role" "get_ps_lambda_role" {
  name = "${local.prefix}-get-ps-lambda-role"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : ""
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
          "Effect" : "Allow",
        }
      ]
    }
  )
}

// for All
resource "aws_iam_role_policy_attachment" "lamnda_common_role_basic_policy" {
  role       = aws_iam_role.get_ps_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

// for GetParameterStore
resource "aws_iam_role_policy" "lamnda_common_role_ssm_ps_policy" {
  role = aws_iam_role.get_ps_lambda_role.name
  name = "ssm-parameter-store-read-policy"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : ""
          "Action" : [
            "ssm:GetParameter",
            "kms:Decrypt",
          ],
          "Effect" : "Allow",
          "Resource" : "*",
        }
      ]
    }
  )
}
