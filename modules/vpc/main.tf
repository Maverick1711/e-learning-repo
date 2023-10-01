#Create VPC
resource "aws_vpc" "e-learning-vpc" {
  cidr_block       = var.vpc-cidr-block
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "e-learning-vpc"
  }
}

# Create availabity zones
# Declare the data source
data "aws_availability_zones" "availabilty_zones" {
  state = "available"
}


# Create public subnet 1 in az1
resource "aws_subnet" "e-learning-pub-sub-1" {
  vpc_id     = aws_vpc.e-learning-vpc.id
  cidr_block = var.pub-sub-1-cidr-block
  availability_zone =  data.aws_availability_zones.availabilty_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "e-learning-pub-sub-1"
  }
}


# Create public subnet 2 in az2
resource "aws_subnet" "e-learning-pub-sub-2" {
  vpc_id     = aws_vpc.e-learning-vpc.id
  cidr_block = var.pub-sub-2-cidr-block
  availability_zone =  data.aws_availability_zones.availabilty_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "e-learning-pub-sub-2"
  }
}


# Create private subnet 1 in az1
resource "aws_subnet" "e-learning-priv-sub-1" {
  vpc_id     = aws_vpc.e-learning-vpc.id
  cidr_block = var.priv-sub-1-cidr-block
  availability_zone =  data.aws_availability_zones.availabilty_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "e-learning-priv-sub-1"
  }
}


# Create private subnet 2 in az2
resource "aws_subnet" "e-learning-priv-sub-2" {
  vpc_id     = aws_vpc.e-learning-vpc.id
  cidr_block = var.priv-sub-2-cidr-block
  availability_zone =  data.aws_availability_zones.availabilty_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "e-learning-priv-sub-2"
  }
}


# Create internet gateway
resource "aws_internet_gateway" "e-learning-igw" {
  vpc_id = aws_vpc.e-learning-vpc.id

  tags = {
    Name = "e-learning-igw"
  }

}


# Create Elastic IP
resource "aws_eip" "e-learning-eip" {
  vpc      = true

  tags = {
    Name = "e-learning-eip"
  }
}


# Create Nat gateway in public subnet az1
resource "aws_nat_gateway" "e-learning-natgw" {
  allocation_id = aws_eip.e-learning-eip.id
  subnet_id     = aws_subnet.e-learning-pub-sub-1.id

  tags = {
    Name = "e-learning-natgw"
  }

  depends_on = [aws_internet_gateway.e-learning-igw]

}


# Create public route table
resource "aws_route_table" "e-learning-public-rtb" {
  vpc_id = aws_vpc.e-learning-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.e-learning-igw.id
  }

  tags = {
    Name = "e-learning-public-rtb"
  }
}


# Create private route table
resource "aws_route_table" "e-learning-private-rtb" {
  vpc_id = aws_vpc.e-learning-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.e-learning-natgw.id

  }

  tags = {
    Name = "e-learning-private-rtb"
  }
}


# Create route table association for public subnet 1
resource "aws_route_table_association" "e-learning-pub-sub-1-rtb-assoc" {
  subnet_id      = aws_subnet.e-learning-pub-sub-1.id
  route_table_id = aws_route_table.e-learning-public-rtb.id
}



# Create route table association for public subnet 2
resource "aws_route_table_association" "e-learning-pub-sub-2-rtb-assoc" {
  subnet_id      = aws_subnet.e-learning-pub-sub-2.id
  route_table_id = aws_route_table.e-learning-public-rtb.id
}



# Create route table association for private subnet 1
resource "aws_route_table_association" "e-learning-priv-sub-1-rtb-assoc" {
  subnet_id      = aws_subnet.e-learning-priv-sub-1.id
  route_table_id = aws_route_table.e-learning-private-rtb.id
}



# Create route table association for private subnet 2
resource "aws_route_table_association" "e-learning-priv-sub-2-rtb-assoc" {
  subnet_id      = aws_subnet.e-learning-priv-sub-2.id
  route_table_id = aws_route_table.e-learning-private-rtb.id
}


