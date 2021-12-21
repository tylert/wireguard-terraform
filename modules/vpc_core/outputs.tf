/*
             _               _
  ___  _   _| |_ _ __  _   _| |_ ___
 / _ \| | | | __| '_ \| | | | __/ __|
| (_) | |_| | |_| |_) | |_| | |_\__ \
 \___/ \__,_|\__| .__/ \__,_|\__|___/
                |_|
*/

output "network_acl_id_public" {
  value = aws_network_acl.public.id
}

output "network_acl_id_private" {
  value = aws_network_acl.private.id
}

output "network_acl_id_secure" {
  value = aws_network_acl.secure.id
}

output "route_table_ids_public" {
  value = aws_route_table.public_az[*].id
}

output "route_table_ids_private" {
  value = aws_route_table.private_az[*].id
}

output "route_table_ids_secure" {
  value = aws_route_table.secure_az[*].id
}

output "security_group_id_public" {
  value = aws_security_group.public.id
}

output "security_group_id_private" {
  value = aws_security_group.private.id
}

output "security_group_id_secure" {
  value = aws_security_group.secure.id
}

output "subnet_ids_public" {
  value = aws_subnet.public_az[*].id
}

output "subnet_ids_private" {
  value = aws_subnet.private_az[*].id
}

output "subnet_ids_secure" {
  value = aws_subnet.secure_az[*].id
}

output "vpc_id" {
  value = aws_vpc.main.id
}
