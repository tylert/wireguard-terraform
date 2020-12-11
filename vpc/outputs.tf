/*
             _               _
  ___  _   _| |_ _ __  _   _| |_ ___
 / _ \| | | | __| '_ \| | | | __/ __|
| (_) | |_| | |_| |_) | |_| | |_\__ \
 \___/ \__,_|\__| .__/ \__,_|\__|___/
                |_|
*/

output "basename" {
  value = var.basename
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

output "route_table_ids_public" {
  value = aws_route_table.public_az[*].id
}

output "route_table_ids_private" {
  value = aws_route_table.private_az[*].id
}

output "route_table_ids_secure" {
  value = aws_route_table.secure_az[*].id
}

output "vpc_id" {
  value = aws_vpc.main.id
}
