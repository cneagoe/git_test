resource "aws_db_instance" "default" {
    allocated_storage    = 20
    engine               = "mysql"
    engine_version       = "8.0"
    instance_class       = "db.t2.micro"
    identifier           = var.db_name
    username             = var.db_username
    password             = var.db_password
    parameter_group_name = "default.mysql8.0"
    publicly_accessible  = false
    skip_final_snapshot  = true
    db_subnet_group_name = aws_db_subnet_group.default.name
    vpc_security_group_ids = [aws_security_group.rds_sg.id]
	
	tags = {
        Name = var.db_name
    }
}

resource "aws_db_subnet_group" "default" {
    name       = "${var.db_name}-subnet-group"
    subnet_ids = var.private_subnets

    tags = {
        Name = "${var.db_name}-subnet-group"
        }
    }

resource "aws_security_group" "rds_sg" {
    name   = "rds_sg"
    vpc_id = var.vpc_id

    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        security_groups = [var.sg_id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "rds_sg"
    }
}