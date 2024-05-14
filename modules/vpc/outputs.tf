output "vpc_id" {
    value = aws_vpc.main.id
}

output "public_subnets" {
    value = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
}

output "private_subnets" {
    value = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
}