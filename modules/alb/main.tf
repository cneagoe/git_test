 resource "aws_alb" "main" {
    name            = "main-alb"
    subnets         = var.public_subnets
    security_groups = [aws_security_group.alb_sg.id]

    tags = {
        Name = "main_alb"
    }
}

resource "aws_alb_target_group" "main" {
    name     = "alb-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id

    health_check {
        enabled = true
        path    = "/"
        port    = "80"
    }

    tags = {
        Name = "main_tg"
    }
}

resource "aws_alb_listener" "front_end" {
    load_balancer_arn = aws_alb.main.arn
    port              = "80"
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_alb_target_group.main.arn
    }
}

resource "aws_security_group" "alb_sg" {
    name   = "alb_sg"
    vpc_id = var.vpc_id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
	
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "alb_sg"
    }
}
