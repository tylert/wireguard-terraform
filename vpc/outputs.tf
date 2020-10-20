output "vpc_id" {
  value = aws_vpc.main.id
}

output "availability_zones" {
  value = data.aws_availability_zones.available.names
}

# Subnets

output "public_subnet_ids" {
  value = aws_subnet.public_az[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_az[*].id
}

output "secure_subnet_ids" {
  value = aws_subnet.secure_az[*].id
}

# Subnet IPv4 ranges

output "public_subnet_ipv4_cidrs" {
  value = aws_subnet.public_az[*].cidr_block
}

output "private_subnet_ipv4_cidrs" {
  value = aws_subnet.private_az[*].cidr_block
}

output "secure_subnet_ipv4_cidrs" {
  value = aws_subnet.secure_az[*].cidr_block
}

# Subnet IPv6 ranges

output "public_subnet_ipv6_cidrs" {
  value = aws_subnet.public_az[*].ipv6_cidr_block
}

output "private_subnet_ipv6_cidrs" {
  value = aws_subnet.private_az[*].ipv6_cidr_block
}

output "secure_subnet_ipv6_cidrs" {
  value = aws_subnet.secure_az[*].ipv6_cidr_block
}

# output "nat_gateways" {
#   value = aws_nat_gateway.az[*].public_ip
# }

output "public_security_group_ids" {
  value = aws_security_group.public.id
}

output "private_security_group" {
  value = aws_security_group.private.id
}
