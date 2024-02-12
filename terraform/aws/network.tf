# Create a VPC with a /16 (65,536 IP addresses) IPv4 CIDR block
resource "aws_vpc" "main" {
  assign_generated_ipv6_cidr_block = false
  cidr_block                       = var.vpc_cidr_block
  enable_dns_hostnames             = true
  enable_dns_support               = true
  instance_tenancy                 = "default"
  tags                             = var.tags
}

# Create a private subnet with a /24 (256 IP addresses) IPv4 CIDR block
resource "aws_subnet" "private_subnet" {
  count                           = length(var.availability_zones)
  assign_ipv6_address_on_creation = false
  availability_zone               = element(var.availability_zones, count.index)
  cidr_block                      = element(var.private_subnet_cidr_blocks, count.index)
  map_public_ip_on_launch         = false
  tags                            = var.tags
  vpc_id                          = aws_vpc.main.id
}

# Create a public subnet with a /24 (256 IP addresses) IPv4 CIDR block
resource "aws_subnet" "public_subnet" {
  count                   = length(var.availability_zones)
  availability_zone       = element(var.availability_zones, count.index)
  cidr_block              = element(var.public_subnet_cidr_blocks, count.index)
  map_public_ip_on_launch = true
  tags                    = var.tags
  vpc_id                  = aws_vpc.main.id
}

# Create Internet Gateway for the public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = var.tags

  depends_on = [
    aws_vpc.main,
  ]
}

# Create Elastic IP
resource "aws_eip" "elastic_ip" {
  public_ipv4_pool = "amazon"
  domain           = "vpc"
  tags             = var.tags
}

# Create NAT Gateway
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = var.tags
  depends_on = [
    aws_eip.elastic_ip,
    aws_subnet.public_subnet,
  ]
}


# Create a route table for the VPC with a single route that sends all traffic to the Internet Gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = var.tags
  depends_on = [
    aws_internet_gateway.igw,
  ]
}

# Associate the public subnet with the public route table
resource "aws_route_table_association" "internet_access" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public.id

  depends_on = [
    aws_subnet.public_subnet,
    aws_route_table.public,
  ]
}

# Add route to route table
resource "aws_route" "main" {
  route_table_id         = aws_vpc.main.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id

  depends_on = [
    aws_vpc.main,
    aws_internet_gateway.igw,
  ]
}
