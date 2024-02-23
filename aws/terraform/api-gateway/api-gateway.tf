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
      # 認証 - Basic認証（Lambda）
      #-------------------------------------
      "/auth/basic" : {
        "x-amazon-apigateway-any-method" : {
          "security" : [{
            "basic-auth" : []
          }],
          "x-amazon-apigateway-integration" : {
            "httpMethod" : "POST",
            "uri" : aws_lambda_function.event_dump_lambda.invoke_arn,
            "responses" : {
              "default" : {
                "statusCode" : "200"
              }
            },
            "passthroughBehavior" : "when_no_match",
            "contentHandling" : "CONVERT_TO_TEXT",
            "type" : "aws_proxy"
          },
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
    # ゲートウェイレスポンス
    #-------------------------------------
    "x-amazon-apigateway-gateway-responses" : {
      # ブラウザでBasic認証ダイアログを出すために必要。
      # ダイアログを出さないなら不要。
      "UNAUTHORIZED" : {
        "statusCode" : 401,
        "responseParameters" : {
          "gatewayresponse.header.WWW-Authenticate" : "'Basic'"
        },
        "responseTemplates" : {
          "application/json" : "{\"message\":$context.error.messageString}"
        }
      },
    }

    #-------------------------------------
    # オーソライザー
    #-------------------------------------
    components = {
      "securitySchemes" : {
        # API-Key認証
        "api_key" : {
          "type" : "apiKey",
          "name" : "x-api-key",
          "in" : "header"
        },
        # Basic認証
        # ブラウザで認証ダイアログを出すにはGatewayResponseの設定が必要。
        "basic-auth" : {
          "type" : "apiKey",
          "name" : "authorization",
          "in" : "header",
          "x-amazon-apigateway-authtype" : "custom",
          "x-amazon-apigateway-authorizer" : {
            "authorizerUri" : aws_lambda_function.basic_authorizer_lambda.invoke_arn,
            "authorizerCredentials" : aws_iam_role.apigw_authorizer_invoke_role.arn,
            "authorizerResultTtlInSeconds" : 60,
            "type" : "token"
            # "identityValidationExpression" : "^[a-zA-Z0-9]+$",
          }
        },
        # カスタム（特定ヘッダのみをLambdaに渡す）
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
        # カスタム（すべてのINPUTをLambdaに渡す）
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

