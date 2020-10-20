output "vpc_id" {
  value = aws_vpc.main.id
}

output "availability_zones" {
  value = data.aws_availability_zones.available.names
}

output "public_subnet_ids" {
  value = aws_subnet.public_az[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_az[*].id
}

output "public_subnet_ipv4_cidrs" {
  value = aws_subnet.public_az[*].cidr_block
}

output "private_subnet_ipv4_cidrs" {
  value = aws_subnet.private_az[*].cidr_block
}

output "public_subnet_ipv6_cidrs" {
  value = aws_subnet.public_az[*].ipv6_cidr_block
}

output "private_subnet_ipv6_cidrs" {
  value = aws_subnet.private_az[*].ipv6_cidr_block
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
