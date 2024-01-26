
module "event_dump" {
  source      = "./modules/event_dump/"
  base_prefix = "${local.prefix}-01"
}

module "parameter_store" {
  source      = "./modules/get_parameter_store/"
  base_prefix = "${local.prefix}-02"
  region      = local.region
}

module "multiple_modules_in_layers" {
  source      = "./modules/multiple_modules_in_layers/"
  base_prefix = "${local.prefix}-03"
}


