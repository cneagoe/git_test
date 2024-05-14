 resource "aws_instance" "webserver1" {
    ami           = var.ami_id
    instance_type = var.instance_type
    subnet_id     = var.public_subnets[0]
    key_name      = var.key_name
	vpc_security_group_ids = [var.webserver_sg_id]
	
	user_data = <<-EOF
                #!/bin/bash
                sudo yum install -y httpd
                sudo systemctl start httpd
                sudo systemctl enable httpd
                INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
                AVAILABILITY_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
                REGION=$${AVAILABILITY_ZONE::-1}
                echo "<h1>LUIT Week22 - Johnny Mac - July 2023</h1>" | sudo tee /var/www/html/index.html
                echo "<p>Instance ID: $INSTANCE_ID</p>" | sudo tee -a /var/www/html/index.html
                echo "<p>Region: $REGION</p>" | sudo tee -a /var/www/html/index.html
                echo "<p>Availability Zone: $AVAILABILITY_ZONE</p>" | sudo tee -a /var/www/html/index.html
                echo "<p>Date and Time: $(date)</p>" | sudo tee -a /var/www/html/index.html                
                sudo systemctl restart httpd
                EOF

    tags = {
        Name = "webserver1"
    }
}

resource "aws_instance" "webserver2" {
    ami           = var.ami_id
    instance_type = var.instance_type
    subnet_id     = var.public_subnets[1]
    key_name      = var.key_name
	vpc_security_group_ids = [var.webserver_sg_id]
	
	user_data = <<-EOF
                #!/bin/bash
                sudo yum install -y httpd
                sudo systemctl start httpd
                sudo systemctl enable httpd
                INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
                AVAILABILITY_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
                REGION=$${AVAILABILITY_ZONE::-1}
                echo "<h1>LUIT Week22 - Johnny Mac - July 2023</h1>" | sudo tee /var/www/html/index.html
                echo "<p>Instance ID: $INSTANCE_ID</p>" | sudo tee -a /var/www/html/index.html
                echo "<p>Region: $REGION</p>" | sudo tee -a /var/www/html/index.html
                echo "<p>Availability Zone: $AVAILABILITY_ZONE</p>" | sudo tee -a /var/www/html/index.html
                sudo systemctl restart httpd
                EOF

    tags = {
        Name = "webserver2"
    }
}

resource "aws_alb_target_group_attachment" "attachment1" {
    target_group_arn = var.target_group_arn
    target_id        = aws_instance.webserver1.id
    port             = 80
}

resource "aws_alb_target_group_attachment" "attachment2" {
    target_group_arn = var.target_group_arn
    target_id        = aws_instance.webserver2.id
    port             = 80
}