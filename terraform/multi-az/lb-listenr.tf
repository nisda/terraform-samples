resource "aws_lb" "sample_lb" {
  name                             = local.name.sample_lb
  load_balancer_type               = "network"
  enable_cross_zone_load_balancing = "true"
  internal                         = true
  subnets                          = values(aws_subnet.sample_subnet)[*].id
}