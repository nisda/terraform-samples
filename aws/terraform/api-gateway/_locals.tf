locals {
  region       = "ap-northeast-1"
  project_name = "apigw-sample"
  env          = "poc"
  prefix       = "apigw-${local.env}"
}

data "http" "my_public_ip" {
  url = "https://ipv4.icanhazip.com/"
}
locals {
  my_public_ip = trimspace(data.http.my_public_ip.response_body)

  lambda_func_src_dir          = "${path.root}/${path.module}/lambda-functions/src"
  lambda_func_tmp_dir          = "${path.root}/${path.module}/lambda-functions/.tmp"
  lambda_log_retention_in_days = 14
}

