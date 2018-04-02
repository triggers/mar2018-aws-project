provider "aws" {
  region = "${var.aws_region}"
}

# https://www.terraform.io/docs/providers/aws/d/ami.html

data "aws_ami" "centos_ami" {
  most_recent = true

  # https://groups.google.com/forum/#!topic/terraform-tool/gHhxTlOAry0
  owners            = ["679593333241"]

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS*"]
  }
}


# https://www.terraform.io/docs/providers/aws/r/eip_association.html

### CentOS WEB VM INSTANCES

resource "aws_eip_association" "web_eip_assoc" {
  allocation_id = "${var.web_server_eip_id}"
  network_interface_id = "${aws_network_interface.web-server-eth0-nic.id}"
}

resource "aws_network_interface" "web-server-eth0-nic" {
  subnet_id = "${var.subnet_external_id}"
  private_ips = ["${var.private_ip}"]
  security_groups = ["${var.sgroup_id}"]
  source_dest_check = "false" # route pseudo internet on external subnet
  tags {
    Name = "web server external interface"
  }
}

resource "aws_instance" "web_server" {
  ami           = "${data.aws_ami.centos_ami.id}"
  instance_type = "t2.micro"

  key_name="development-key"

  network_interface {
     network_interface_id = "${aws_network_interface.web-server-eth0-nic.id}"
     device_index = 0
  }

  tags {
    Name = "Web server instance"
  }
}
