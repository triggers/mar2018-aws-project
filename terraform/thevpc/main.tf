provider "aws" {
  region = "${var.aws_region}"
}


# https://www.terraform.io/docs/providers/tls/r/private_key.html

resource "tls_private_key" "dev_sshkey" {
  algorithm   = "RSA"
}

# https://www.terraform.io/docs/providers/aws/r/key_pair.html

resource "aws_key_pair" "sshkey_for_ec2" {
  key_name   = "development-key"
  public_key = "${tls_private_key.dev_sshkey.public_key_openssh}"
}


# https://www.terraform.io/docs/providers/aws/r/instance.html

resource "aws_vpc" "the_vpc" {
  cidr_block = "10.10.0.0/16"
  tags {
    Name = "VPC"
  }
}

resource "aws_subnet" "subnet_external" {
  vpc_id = "${aws_vpc.the_vpc.id}"
  cidr_block = "10.10.33.0/24"
  availability_zone = "${var.aws_availability_zone}"
  tags {
    Name = "External Subnet"
  }
}

# https://www.terraform.io/docs/providers/aws/r/internet_gateway.html

resource "aws_internet_gateway" "gw_external" {
  vpc_id = "${aws_vpc.the_vpc.id}"

  tags {
    Name = "GW"
  }
}

# http://blog.kaliloudiaby.com/index.php/terraform-to-provision-vpc-on-aws-amazon-web-services/

resource "aws_route" "internet_access_external" {
  route_table_id         = "${aws_vpc.the_vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw_external.id}"
}

# https://www.terraform.io/docs/providers/aws/r/security_group.html

resource "aws_security_group" "external_sg" {
  name        = "Firewall"
  description = "Firewall settings"
  vpc_id      = "${aws_vpc.the_vpc.id}"

  tags {
    Name = "Firewall"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 80
    to_port         = 80
    protocol        = "6"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "6"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

output "external_sg_id" {
  value = "${aws_security_group.external_sg.id}"
}

output "subnet_external_id" {
  value = "${aws_subnet.subnet_external.id}"
}
