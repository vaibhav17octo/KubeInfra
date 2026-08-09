# VPC networking for the cluster: one public and one private subnet in a
# single AZ, with a NAT gateway giving private instances outbound internet.

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  # kubeadm nodes rely on DNS hostname resolution inside the VPC.
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.cluster_name
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[var.az_index]

  # Instances launched here get a public IP so they are directly reachable.
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.cluster_name}-public"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = data.aws_availability_zones.available.names[var.az_index]

  tags = {
    Name = "${var.cluster_name}-private"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.cluster_name
  }
}

# A NAT gateway needs a static public address to translate outbound traffic to.
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "${var.cluster_name}-nat"
  }
}

# The NAT gateway lives in the PUBLIC subnet: it must itself reach the
# internet through the IGW in order to forward traffic on behalf of the
# private subnet.
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.id

  # The IGW must be attached to the VPC before the NAT gateway (and its EIP)
  # can route anything; Terraform can't infer this ordering from references.
  depends_on = [aws_internet_gateway.main]

  tags = {
    Name = var.cluster_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.cluster_name}-public"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name = "${var.cluster_name}-private"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
