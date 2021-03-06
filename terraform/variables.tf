variable "aws_region" {
  description = "aws region"
  default = "ap-northeast-1"
}

variable "aws_availability_zone" {
  description = "aws availability zone"
  default = "ap-northeast-1a"
}

variable "aws_availability_zone2" {
  description = "aws availability zone2"
  default = "ap-northeast-1c"
}

variable "lb_server_eip_id" {
  description = "eip id for load balancer"
  default = "eipalloc-42cdec78"
}

variable "step_server_eip_id" {
  description = "eip id for step server"
  default = "eipalloc-44d9f87e"
}

variable "web1_server_private_ip" {
  description = "private IP for web server #1"
  default = "10.10.33.11"
}

variable "web2_server_private_ip" {
  description = "private IP for web server #2"
  default = "10.10.33.12"
}

variable "step_server_private_ip" {
  description = "private IP for web server #2"
  default = "10.10.33.10"
}
