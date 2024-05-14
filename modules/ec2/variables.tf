variable "public_subnets" {
    type = list(string)
}

variable "ami_id" {}

variable "instance_type" {}

variable "key_name" {}

variable "webserver_sg_id" {
  description = "Security group ID for the web servers"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the target group for ALB"
}