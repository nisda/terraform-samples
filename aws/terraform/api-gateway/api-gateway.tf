resource "aws_api_gateway_rest_api" "sample_rest_api" {
  name = local.name.sample_rest_api
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title   = "Overridden by `name`"
      version = "1.0"
    }
    # [reference]
    #   https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/api-gateway-swagger-extensions.html
    paths = {
      "/" : {
        "x-amazon-apigateway-any-method" : {
          "x-amazon-apigateway-integration" : {
            "type" : "AWS_PROXY",
            "httpMethod" : "POST",
            "uri" : aws_lambda_function.sample_lambda_function.invoke_arn
            "timeoutInMillis" : 1000,
            "connectionType" : "INTERNET",
            "payloadFormatVersion" : 1.0
          }
        }
      }
      "/{proxy+}" : {
        "x-amazon-apigateway-any-method" : {
          "parameters" : [
            {
              "name" : "proxy",
              "in" : "path",
              "required" : true,
              "type" : "string"
            }
          ],
          "x-amazon-apigateway-integration" : {
            "type" : "AWS_PROXY",
            "httpMethod" : "POST",
            "uri" : aws_lambda_function.sample_lambda_function.invoke_arn
            "timeoutInMillis" : 1000,
            "connectionType" : "INTERNET",
            "payloadFormatVersion" : 1.0
          }
        }
      }
      "/http" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod           = "GET"
            payloadFormatVersion = "1.0"
            type                 = "HTTP_PROXY"
            uri                  = "https://example.com/"
          }
        }
      }
    }
  })
}

resource "aws_api_gateway_deployment" "sample_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.sample_rest_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.sample_rest_api.body))
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

