resource "aws_vpc" "default" {
  cidr_block = "10.1.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "private1" {
  cidr_block = "10.1.1.0/24"
  vpc_id = aws_vpc.default.id
  availability_zone = "ap-northeast-1a"
}

resource "aws_subnet" "private2" {
  cidr_block = "10.1.2.0/24"
  vpc_id = aws_vpc.default.id
  availability_zone = "ap-northeast-1c"
}

resource "aws_vpc_endpoint" "ap-northeast-1-s3" {
  service_name = "com.amazonaws.ap-northeast-1.s3"
  vpc_id = aws_vpc.default.id
}

resource "aws_vpc_endpoint" "ap-northeast-1-logs" {
  service_name = "com.amazonaws.ap-northeast-1.logs"
  vpc_id = aws_vpc.default.id
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true

  security_group_ids = [
    aws_security_group.vpc-endpoint-security-group.id
  ]

  subnet_ids = [
    aws_subnet.private1.id,
    aws_subnet.private2.id,
  ]
}

resource "aws_vpc_endpoint" "ap-northeast-1-ecr-dkr" {
  service_name = "com.amazonaws.ap-northeast-1.ecr.dkr"
  vpc_id = aws_vpc.default.id
  vpc_endpoint_type = "Interface"

  private_dns_enabled = true

  security_group_ids = [
    aws_security_group.vpc-endpoint-security-group.id
  ]

  subnet_ids = [
    aws_subnet.private1.id,
    aws_subnet.private2.id,
  ]
}

resource "aws_security_group" "vpc-endpoint-security-group" {
  name = "vpc-endpoint"
  vpc_id = aws_vpc.default.id
}

resource "aws_security_group_rule" "vpc-endpoint-security-group" {
  cidr_blocks = [
    "10.1.0.0/16"
  ]

  protocol = "tcp"
  security_group_id = aws_security_group.vpc-endpoint-security-group.id

  from_port = 443
  to_port = 443

  type = "ingress"
}

resource "aws_security_group_rule" "vpc-endpoint-security-group-1" {
  cidr_blocks = [
    "0.0.0.0/0"
  ]

  protocol = "-1"
  security_group_id = aws_security_group.vpc-endpoint-security-group.id

  from_port = 0
  to_port = 0

  type = "egress"
}

resource "aws_route_table" "default" {
  vpc_id = aws_vpc.default.id
}

resource "aws_vpc_endpoint_route_table_association" "s3" {
  route_table_id = aws_route_table.default.id
  vpc_endpoint_id = aws_vpc_endpoint.ap-northeast-1-s3.id
}

resource "aws_route_table_association" "default1" {
  route_table_id = aws_route_table.default.id
  subnet_id = aws_subnet.private1.id
}

resource "aws_route_table_association" "default2" {
  route_table_id = aws_route_table.default.id
  subnet_id = aws_subnet.private2.id
}