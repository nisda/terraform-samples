locals {
  name = {
    sample_vpc         = "${var.prefix}-vpc"
    sample_subnet_base = "${var.prefix}-subnet"
    sample_rt          = "${var.prefix}-rt"
    sample_lb          = "${var.prefix}-lb"
  }
}