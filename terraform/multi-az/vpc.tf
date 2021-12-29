resource "aws_vpc" "sample_vpc" {
  cidr_block = local.config.cidr.sample_vpc
  tags = {
    Name = local.name.sample_vpc
  }
}