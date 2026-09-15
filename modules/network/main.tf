locals {
  subnets = {
    for index, az in var.availability_zones : az => {
      private_cidr = var.private_subnet_cidrs[index]
      public_cidr  = var.public_subnet_cidrs[index]
    }
  }
  nat_gateway_azs = {
    for az, subnet in local.subnets : az => subnet
    if !var.single_nat_gateway || az == var.availability_zones[0]
  }
  common_tags = merge(var.tags, { "managed-by" = "terraform", "component" = "network" })
}

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(local.common_tags, { Name = var.name })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.common_tags, { Name = "${var.name}-igw" })
}

resource "aws_subnet" "public" {
  for_each                = local.subnets
  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = each.value.public_cidr
  map_public_ip_on_launch = false

  tags = merge(local.common_tags, {
    Name                     = "${var.name}-public-${each.key}"
    "kubernetes.io/role/elb" = "1"
  })
}

resource "aws_subnet" "private" {
  for_each          = local.subnets
  vpc_id            = aws_vpc.this.id
  availability_zone = each.key
  cidr_block        = each.value.private_cidr

  tags = merge(local.common_tags, {
    Name                              = "${var.name}-private-${each.key}"
    "kubernetes.io/role/internal-elb" = "1"
  })
}

resource "aws_eip" "nat" {
  for_each = local.nat_gateway_azs
  domain   = "vpc"
  tags     = merge(local.common_tags, { Name = "${var.name}-nat-${each.key}" })
}

resource "aws_nat_gateway" "this" {
  for_each      = local.nat_gateway_azs
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id
  tags          = merge(local.common_tags, { Name = "${var.name}-nat-${each.key}" })

  depends_on = [aws_internet_gateway.this]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = merge(local.common_tags, { Name = "${var.name}-public" })
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  for_each = local.subnets
  vpc_id   = aws_vpc.this.id
  tags     = merge(local.common_tags, { Name = "${var.name}-private-${each.key}" })
}

resource "aws_route" "private_nat" {
  for_each = local.subnets

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.this[
    var.single_nat_gateway ? var.availability_zones[0] : each.key
  ].id
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_security_group" "endpoints" {
  name_prefix = "${var.name}-endpoints-"
  description = "Permit HTTPS from workloads to interface VPC endpoints."
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "HTTPS from within the VPC"
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, { Name = "${var.name}-endpoints" })
}

resource "aws_vpc_endpoint" "interface" {
  for_each = toset(["ecr.api", "ecr.dkr", "logs", "sts"])

  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.${each.value}"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = values(aws_subnet.private)[*].id
  security_group_ids  = [aws_security_group.endpoints.id]
  tags                = merge(local.common_tags, { Name = "${var.name}-${replace(each.value, ".", "-")}" })
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = values(aws_route_table.private)[*].id
  tags              = merge(local.common_tags, { Name = "${var.name}-s3" })
}

data "aws_region" "current" {}
