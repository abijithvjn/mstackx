module "kubernetes-node" {
  source = "../../modules/asg/"
  name = "kube-node"
  ebs_optimized = "false"
  key_pair_name = "${var.key_pair_name}"
  ami           = "${var.ubuntu16_ami}"
  instance_type = "${lookup(var.instance_type,"kube-node")}"
  iam_instance_profile = "${aws_iam_instance_profile.kube-node-profile.name}"
  volume_size     = "100"
  security_groups = "${aws_security_group.main_internal_sg.id}"
  user_data_template = "kube_nodes"
  asg_subnets   = "${element(module.main_vpc.private_subnet_id,0)},${element(module.main_vpc.private_subnet_id,1)}"
}
