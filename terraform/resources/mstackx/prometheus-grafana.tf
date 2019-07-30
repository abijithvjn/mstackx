module "prometheus-grafana" {
  source = "../../modules/ec2/"
  name = "prometheus-grafana"
  role = "prometheus-grafana"
  count    = 1
  ebs_optimized = "false"
  key_pair_name = "${var.key_pair_name}"
  ami           = "${var.ubuntu_ami}"
  instance_type = "${lookup(var.instance_type,"prometheus")}"
  subnet_id       = "${element(module.main_vpc.public_subnet_id,0)}"
  iam_instance_profile = "${aws_iam_instance_profile.ec2-default-profile.name}"
  associate_public_ip_address = "true"

  volume_size     = "100"
  security_groups = "${aws_security_group.main_public_sg.id}"
}

resource "aws_eip" "grafana_elastic_ip" {
  vpc     = true
  instance = "${element(module.prometheus-grafana.instance_id, 0)}"
  tags      {
                Name = "${var.name}-grafana-ip"
            }
  lifecycle { create_before_destroy = true }
  depends_on = ["module.prometheus-grafana"]
}
