output "alb_dns_name" {
    value = aws_alb.main.dns_name
}

output "alb_sg_id" {
    value = aws_security_group.alb_sg.id
}

output "target_group_arn" {
    description = "ARN of the target group for ALB"
    value       = aws_alb_target_group.main.arn
}