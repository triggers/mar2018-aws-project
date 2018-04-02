provider "aws" {
  region = "${var.aws_region}"
}

module "thevpc" {
  source = "./thevpc"
  aws_region="${var.aws_region}"
  aws_availability_zone="${var.aws_availability_zone}"
}

module "web1vm" {
  source = "./webvm"
  aws_region="${var.aws_region}"
  aws_availability_zone="${var.aws_availability_zone}"
  subnet_external_id = "${module.thevpc.subnet_external_id}"
  sgroup_id = "${module.thevpc.external_sg_id}"
  private_ip="${var.web1_server_private_ip}"
  web_server_eip_id="${var.web1_server_eip_id}"
}

module "web2vm" {
  source = "./webvm"
  aws_region="${var.aws_region}"
  aws_availability_zone="${var.aws_availability_zone}"
  subnet_external_id = "${module.thevpc.subnet_external_id}"
  sgroup_id = "${module.thevpc.external_sg_id}"
  private_ip="${var.web2_server_private_ip}"
  web_server_eip_id="${var.web2_server_eip_id}"
}

module "rdsvm" {
  source = "./therds"
  aws_region="${var.aws_region}"
  aws_availability_zone="${var.aws_availability_zone}"
  subnet_external_id = "${module.thevpc.subnet_external_id}"
  sgroup_id = "${module.thevpc.external_sg_id}"
  private_ip="${var.web2_server_private_ip}"
  web_server_eip_id="${var.web2_server_eip_id}"
}
