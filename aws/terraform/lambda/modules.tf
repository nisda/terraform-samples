
module "event_dump" {
  source      = "./modules/event_dump/"
  base_prefix = "${local.prefix}-01"
}

module "parameter_store" {
  source      = "./modules/get_parameter_store/"
  base_prefix = "${local.prefix}-02"
  region      = local.region
}

module "rest_api_request" {
  source      = "./modules/rest_api_request/"
  base_prefix = "${local.prefix}-03"
}

