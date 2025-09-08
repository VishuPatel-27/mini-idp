output "private_subnet_ids" {
  value       = [aws_subnet.private_vpc_subnet_az1.id, aws_subnet.private_vpc_subnet_az2.id]
  description = "The ID of the private subnet in availability zone 1 & 2"
  sensitive   = true # Marks the output as sensitive, preventing its display in console or logs.
  depends_on  = [aws_subnet.private_vpc_subnet_az1, aws_subnet.private_vpc_subnet_az2] # Explicitly defines dependencies.
}

output "public_subnet_ids" {
  value       = [aws_subnet.public_vpc_subnet_az1.id, aws_subnet.public_vpc_subnet_az2.id]
  description = "The ID of the public subnet in availability zone 1 & 2"
  sensitive   = true # Marks the output as sensitive, preventing its display in console or logs.
  depends_on  = [aws_subnet.public_vpc_subnet_az1, aws_subnet.public_vpc_subnet_az2 ] # Explicitly defines dependencies.
}