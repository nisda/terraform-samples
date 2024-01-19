//---------------------------------------
//  APIリクエスト
//---------------------------------------
data "archive_file" "rest_api_lambda_layer" {
  type        = "zip"
  source_dir  = "${local.lambda_layer_src_dir}/RestAPI"
  output_path = "${local.lambda_layer_tmp_dir}/RestAPI.zip"
}

resource "aws_lambda_layer_version" "rest_api_lambda" {
  layer_name       = "${local.prefix}-rest-api-layer"
  filename         = data.archive_file.rest_api_lambda_layer.output_path
  source_code_hash = data.archive_file.rest_api_lambda_layer.output_base64sha256

  compatible_runtimes = [
    "python3.6",
    "python3.7",
    "python3.8",
    "python3.9",
    "python3.10",
    "python3.11",
    "python3.12",
  ]
}