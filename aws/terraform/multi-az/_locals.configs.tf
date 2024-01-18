locals {
  config = {
    cidr = {
      sample_vpc            = "10.0.0.0/16"
      sample_subnet_prefix  = "10.0.0.0/24"
      sample_subnet_newbits = 3 # 10.0.0.0/27, 10.0.0.32/27, 10.0.0.64/27, ...
    }
  }
}