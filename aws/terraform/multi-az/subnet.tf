resource "aws_subnet" "sample_subnet" {
  for_each          = var.azs
  vpc_id            = aws_vpc.sample_vpc.id
  availability_zone = each.value
  cidr_block = cidrsubnet(
    local.config.cidr.sample_subnet_prefix,
    local.config.cidr.sample_subnet_newbits,
    index(keys(var.azs), each.key)
  )
  tags = {
    Name = "${local.name.sample_subnet_base}-${split("-", each.value)[2]}"
  }
}


resource "aws_route_table" "sample_rt" {
  vpc_id = aws_vpc.sample_vpc.id
  tags = {
    Name = "${local.name.sample_rt}"
  }
}

resource "aws_route_table_association" "sample_rt_assoc" {
  for_each       = var.azs
  subnet_id      = aws_subnet.sample_subnet[each.key].id
  route_table_id = aws_route_table.sample_rt.id
}
