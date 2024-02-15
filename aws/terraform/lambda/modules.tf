
module "skeleton" {
  source      = "./modules/00_skeleton/"
  base_prefix = "${local.prefix}-00"
  region      = local.region
}


module "event_dump" {
  source      = "./modules/10_event_dump/"
  base_prefix = "${local.prefix}-10"
}

module "parameter_store" {
  source      = "./modules/11_get_parameter_store/"
  base_prefix = "${local.prefix}-11"
  region      = local.region
}

module "multiple_modules_in_layers" {
  source      = "./modules/12_multiple_modules_in_layers/"
  base_prefix = "${local.prefix}-12"
}


