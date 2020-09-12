/******************************************************************************
Output Variables
******************************************************************************/

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "availability_zones" {
  value = ["${data.aws_availability_zones.all.names}"]
}

output "public_subnets" {
  value = ["${aws_subnet.public_az.*.id}"]
}

output "protected_subnets" {
  value = ["${aws_subnet.protected_az.*.id}"]
}

/*
output "private_subnets" {
  value = ["${aws_subnet.private_az.*.id}"]
}
*/

output "public_subnets_ipv4" {
  value = ["${aws_subnet.public_az.*.cidr_block}"]
}

output "protected_subnets_ipv4" {
  value = ["${aws_subnet.protected_az.*.cidr_block}"]
}

/*
output "private_subnets_ipv4" {
  value = ["${aws_subnet.private_az.*.cidr_block}"]
}
*/

output "public_subnets_ipv6" {
  value = ["${aws_subnet.public_az.*.ipv6_cidr_block}"]
}

output "protected_subnets_ipv6" {
  value = ["${aws_subnet.protected_az.*.ipv6_cidr_block}"]
}

/*
output "private_subnets_ipv6" {
  value = ["${aws_subnet.private_az.*.ipv6_cidr_block}"]
}
*/

output "nat_gateways" {
  value = ["${aws_nat_gateway.az.*.public_ip}"]
}

output "public_security_group" {
  value = "${aws_security_group.public.id}"
}

output "protected_security_group" {
  value = "${aws_security_group.protected.id}"
}

/*
output "private_security_group" {
  value = "${aws_security_group.private.id}"
}
*/

output "public_bastion_ips" {
  value = ["${aws_instance.public_bastion_az.*.public_ip}"]
}

/*
output "protected_bastion_ips" {
  value = ["${aws_instance.protected_bastion_az.*.private_ip}"]
}
*/

