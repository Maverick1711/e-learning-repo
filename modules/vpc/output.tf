output "vpc_id" {
    value = aws_vpc.e-learning-vpc.id
}

output "vpc-cidr-block" {
    value = aws_vpc.e-learning-vpc.cidr_block
  
}

output "az1" {
    value =  data.aws_availability_zones.availabilty_zones.names[0]
}

output "az2" {
    value =  data.aws_availability_zones.availabilty_zones.names[1]
}

output "internet_gateway" {
    value = aws_internet_gateway.e-learning-igw.id
}

output "pub-sub-1-id" {
    value = aws_subnet.e-learning-pub-sub-1.id
}

output "pub-sub-2-id" {
    value = aws_subnet.e-learning-pub-sub-2.id
}

output "priv-sub-1-id" {
    value = aws_subnet.e-learning-priv-sub-1.id
}

output "priv-sub-2-id" {
    value = aws_subnet.e-learning-priv-sub-2.id
}