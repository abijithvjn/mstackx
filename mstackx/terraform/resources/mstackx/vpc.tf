module "main_vpc" {

  source = "../../modules/vpc/"

  vpc_cidr             = "${var.vpc_cidr}"
  name                 = "${var.vpc_name}"
  az                   = "${var.az}"
  private_subnet_cidrs = "${var.private_subnet_cidrs}"
  public_subnet_cidrs  = "${var.public_subnet_cidrs}"
  whitelist_ips        = "${var.whitelist_ips}"
  bastion_ami          = "${var.bastion_ami}"

}
