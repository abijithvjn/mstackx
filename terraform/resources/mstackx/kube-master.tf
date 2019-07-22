module "kubernetes-master" {
  source = "../../modules/ec2/"
  name = "kube-master"
  role = "kube-master"
  count    = 1
  ebs_optimized = "false"
  key_pair_name = "${var.key_pair_name}"
  ami           = "${var.ubuntu16_ami}"
  instance_type = "${lookup(var.instance_type,"kube-master")}"
  subnet_id       = "${element(module.main_vpc.private_subnet_id,0)} "
  volume_size     = "100"
  security_groups = "${aws_security_group.main_internal_sg.id}"
}
