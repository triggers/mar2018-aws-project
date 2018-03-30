variable "aws_region" {
  description = "aws region"
  default = "ap-northeast-1"
}

variable "aws_availability_zone" {
  description = "aws availability zone"
  default = "ap-northeast-1a"
}

variable "web1_server_eip_id" {
  description = "Web server #1"
  default = "eipalloc-44d9f87e"
}

variable "web2_server_eip_id" {
  description = "Web server #2"
  default = "eipalloc-42cdec78"
}
