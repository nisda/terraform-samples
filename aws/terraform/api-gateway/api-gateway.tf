# #------------------------------------------------------
# # API-Gateway Role  あとでやる
# #------------------------------------------------------
# resource "aws_iam_role" "lambda_common_role" {
#   name               = "${local.prefix}-lambda-common-role"
#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }

# resource "aws_iam_role_policy_attachment" "lambda_common_role_basic_policy" {
#   role       = aws_iam_role.lambda_common_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }


#------------------------------------------------------
# API-Gateway
#------------------------------------------------------
resource "aws_api_gateway_rest_api" "sample_rest_api" {
  name = "${local.prefix}-rest-api"
  endpoint_configuration {
    types = ["REGIONAL"]
  }

  # [reference]
  #   https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/api-gateway-swagger-extensions.html
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "overwritten with `name`"
      version = "1.0"
    }
    paths = {
      #-------------------------------------
      # プロキシ統合, パス固定。
      #-------------------------------------
      "/" : {
        "x-amazon-apigateway-any-method" : {
          "x-amazon-apigateway-integration" : {
            "httpMethod" : "POST",
            "uri" : aws_lambda_function.event_dump_lambda.invoke_arn,
            "passthroughBehavior" : "when_no_match",
            "timeoutInMillis" : 1000,
            "type" : "aws_proxy"
          }
        }
      }


      #-------------------------------------
      # プロキシ統合, パス可変
      #-------------------------------------
      "/{proxy+}" : {
        "x-amazon-apigateway-any-method" : {
          "parameters" : [
            {
              "name" : "proxy",
              "in" : "path",
              "required" : true,
              "schema" : {
                "type" : "string"
              }
            }
          ],
          "x-amazon-apigateway-integration" : {
            "httpMethod" : "POST",
            "uri" : aws_lambda_function.event_dump_lambda.invoke_arn,
            "passthroughBehavior" : "when_no_match",
            "timeoutInMillis" : 1000,
            "type" : "aws_proxy"
          }
        }
      }

      #-------------------------------------
      # パスパラメータ
      #-------------------------------------
      "/path_parameter/{project_id}/{issue_id}/{proxy+}" : {
        "x-amazon-apigateway-any-method" : {
          "parameters" : [
            {
              "name" : "project_id",
              "in" : "path",
              "required" : true,
              "schema" : {
                "type" : "string"
              }
            },
            {
              "name" : "proxy",
              "in" : "path",
              "required" : true,
              "schema" : {
                "type" : "string"
              }
            },
            {
              "name" : "issue_id",
              "in" : "path",
              "required" : true,
              "schema" : {
                "type" : "string"
              }
            }
          ],
          "x-amazon-apigateway-integration" : {
            "httpMethod" : "POST",
            "uri" : aws_lambda_function.event_dump_lambda.invoke_arn,
            "passthroughBehavior" : "when_no_match",
            "timeoutInMillis" : 1000,
            "type" : "aws_proxy"
          }
        }
      }
      #-------------------------------------
      # 認証 - APIキー
      #-------------------------------------
      "/auth/apikey" : {
        "x-amazon-apigateway-any-method" : {
          "security" : [{
            "api_key" : []
          }],
          "x-amazon-apigateway-integration" : {
            "httpMethod" : "POST",
            "uri" : aws_lambda_function.event_dump_lambda.invoke_arn,
            "passthroughBehavior" : "when_no_match",
            "timeoutInMillis" : 1000,
            "type" : "aws_proxy"
          }
        }
      }

      #-------------------------------------
      # 認証 - Lambda(token)
      #-------------------------------------
      "/auth/custom/token" : {
        "x-amazon-apigateway-any-method" : {
          "security" : [{
            "custom-auth-token" : []
          }],
          "x-amazon-apigateway-integration" : {
            "httpMethod" : "POST",
            "uri" : aws_lambda_function.event_dump_lambda.invoke_arn,
            "uri" : "arn:aws:apigateway:ap-northeast-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-northeast-1:991751320010:function:apigw-poc-event-dump/invocations",
            "responses" : {
              "default" : {
                "statusCode" : "200"
              }
            },
            "passthroughBehavior" : "when_no_match",
            "contentHandling" : "CONVERT_TO_TEXT",
            "type" : "aws_proxy"
          }
        }
      }

      #-------------------------------------
      # 認証 - Lambda(request)
      #-------------------------------------
      "/auth/custom/request" : {
        "x-amazon-apigateway-any-method" : {
          "security" : [{
            "custom-auth-request" : []
          }],
          "x-amazon-apigateway-integration" : {
            "httpMethod" : "POST",
            "uri" : aws_lambda_function.event_dump_lambda.invoke_arn,
            "uri" : "arn:aws:apigateway:ap-northeast-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-northeast-1:991751320010:function:apigw-poc-event-dump/invocations",
            "responses" : {
              "default" : {
                "statusCode" : "200"
              }
            },
            "passthroughBehavior" : "when_no_match",
            "contentHandling" : "CONVERT_TO_TEXT",
            "type" : "aws_proxy"
          }
        }
      }

      #-------------------------------------
      # リソースベースポリシー
      #-------------------------------------

      #-------------------------------------
      # HTTPリダイレクト
      #-------------------------------------
      "/http_redirect" : {
        "get" : {
          "x-amazon-apigateway-integration" : {
            "httpMethod" : "GET",
            "uri" : "https://example.com/",
            "passthroughBehavior" : "when_no_match",
            "type" : "http_proxy"
          }
        }
      }
    }

    #-------------------------------------
    # オーソライザー
    #-------------------------------------
    components = {
      "securitySchemes" : {
        "api_key" : {
          "type" : "apiKey",
          "name" : "x-api-key",
          "in" : "header"
        },
        "custom-auth-token" : {
          "type" : "apiKey",
          "name" : "x-api-key",
          "in" : "header",
          "x-amazon-apigateway-authtype" : "custom",
          "x-amazon-apigateway-authorizer" : {
            "authorizerUri" : aws_lambda_function.custom_authorizer_lambda.invoke_arn,
            "authorizerCredentials" : aws_iam_role.apigw_authorizer_invoke_role.arn,
            "authorizerResultTtlInSeconds" : 60,
            "type" : "token"
            "identityValidationExpression" : "^[a-zA-Z0-9]+$",
          }
        },
        "custom-auth-request" : {
          "type" : "apiKey",
          "name" : "x-api-key",
          "in" : "header",
          "x-amazon-apigateway-authtype" : "custom",
          "x-amazon-apigateway-authorizer" : {
            "authorizerUri" : aws_lambda_function.custom_authorizer_lambda.invoke_arn,
            "authorizerCredentials" : aws_iam_role.apigw_authorizer_invoke_role.arn,
            "authorizerResultTtlInSeconds" : 60,
            "type" : "REQUEST",
            "identitySource" : "method.request.header.x-api-key",
            # "identityValidationExpression" : "^[a-z0-9]$",  不使用
          }
        }
      }
    }

    # # リソースポリシー ==> きちんと書くと ResourceArn が自己参照になるためNG。
    # "x-amazon-apigateway-policy" : {
    #   "Version" : "2012-10-17",
    #   "Statement" : [
    #     {
    #       "Effect" : "Allow",
    #       "Principal" : "*",
    #       "Action" : "execute-api:Invoke",
    #       "Resource" : "${aws_api_gateway_rest_api.sample_rest_api.execution_arn}/*"
    #     },
    #     {
    #       "Effect" : "Deny",
    #       "Principal" : "*",
    #       "Action" : "execute-api:Invoke",
    #       "Resource" : "${aws_api_gateway_rest_api.sample_rest_api.execution_arn}/*",
    #       "Condition" : {
    #         "NotIpAddress" : {
    #           "aws:SourceIp" : local.my_public_ip
    #         }
    #       }
    #     }
    #   ]
    # }

  })
}

resource "aws_api_gateway_rest_api_policy" "sample_rest_api_policy" {
  rest_api_id = aws_api_gateway_rest_api.sample_rest_api.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : "*",
          "Action" : "execute-api:Invoke",
          "Resource" : "${aws_api_gateway_rest_api.sample_rest_api.execution_arn}/*",
        },
        {
          # "Effect" : "Deny",
          "Effect" : "Allow",
          "Principal" : "*",
          "Action" : "execute-api:Invoke",
          "Resource" : "${aws_api_gateway_rest_api.sample_rest_api.execution_arn}/*",
          "Condition" : {
            "NotIpAddress" : {
              # /32 要るかも？ ==> 要らない
              "aws:SourceIp" : local.my_public_ip
            }
          }
        }
      ]
    }
  )
}

resource "aws_api_gateway_deployment" "sample_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.sample_rest_api.id
  triggers = {
    redeployment = sha256(jsonencode([
      aws_api_gateway_rest_api.sample_rest_api.body,
      aws_api_gateway_rest_api_policy.sample_rest_api_policy.policy,
    ]))
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "sample_api_dev_stage" {
  deployment_id = aws_api_gateway_deployment.sample_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.sample_rest_api.id
  stage_name    = "dev"
}

