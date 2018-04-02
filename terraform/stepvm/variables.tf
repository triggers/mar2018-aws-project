variable "aws_region" {
  description = "aws region"
}

variable "aws_availability_zone" {
  description = "aws availability zone"
}

variable "private_ip" {
  description = "Private IP to use for the web server"
}

variable "step_server_eip_id" {
  description = "Allocation ID of the elastic IP to use for the web server"
}

variable "subnet_external_id" {
  description = "From thevpc. Must be set by the caller of this module."
}

variable "sgroup_id" {
  description = "From thevpc. Must be set by the caller of this module."
}
