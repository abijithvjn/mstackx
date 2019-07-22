module "elasticsearch" {
  source = "../../modules/ec2/"
  name = "elasticsearch"
  role = "elasticsearch"
  count    = 1
  ebs_optimized = "false"
  key_pair_name = "${var.key_pair_name}"
  ami           = "${var.ubuntu_ami}"
  instance_type = "${lookup(var.instance_type,"elasticsearch")}"
  subnet_id       = "${element(module.main_vpc.private_subnet_id,0)} "
  volume_size     = "100"
  security_groups = "${aws_security_group.main_internal_sg.id}"
}
