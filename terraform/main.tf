provider "aws" {
  region = "${var.aws_region}"
}

module "thevpc" {
  source = "./thevpc"
  aws_region="${var.aws_region}"
  aws_availability_zone="${var.aws_availability_zone}"
  aws_availability_zone2="${var.aws_availability_zone2}"
}

module "web1vm" {
  source = "./webvm"
  aws_region="${var.aws_region}"
  aws_availability_zone="${var.aws_availability_zone}"
  subnet_external_id = "${module.thevpc.subnet_external_id}"
  sgroup_id = "${module.thevpc.external_sg_id}"
  private_ip="${var.web1_server_private_ip}"
}

module "web2vm" {
  source = "./webvm"
  aws_region="${var.aws_region}"
  aws_availability_zone="${var.aws_availability_zone}"
  subnet_external_id = "${module.thevpc.subnet_external_id}"
  sgroup_id = "${module.thevpc.external_sg_id}"
  private_ip="${var.web2_server_private_ip}"
}

module "stepvm" {
  source = "./stepvm"
  aws_region="${var.aws_region}"
  aws_availability_zone="${var.aws_availability_zone}"
  subnet_external_id = "${module.thevpc.subnet_external_id}"
  sgroup_id = "${module.thevpc.external_sg_id}"
  private_ip="${var.step_server_private_ip}"
  step_server_eip_id="${var.step_server_eip_id}"
}

module "rdsvm" {
  source = "./therds"
  aws_region="${var.aws_region}"
}

module "lbvm" {
  source = "./thelb"
  aws_region="${var.aws_region}"
  subnet_external_id = "${module.thevpc.subnet_external_id}"
  subnet2_external_id = "${module.thevpc.subnet2_external_id}"
  sgroup_id = "${module.thevpc.external_sg_id}"
  lb_server_eip_id="${var.lb_server_eip_id}"
}
