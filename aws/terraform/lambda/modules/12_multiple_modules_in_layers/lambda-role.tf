
// for All
resource "aws_iam_role" "multiple_modules_lambda_role" {
  name = "${local.prefix}-multiple-modules-lambda-role"
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
  role       = aws_iam_role.multiple_modules_lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
