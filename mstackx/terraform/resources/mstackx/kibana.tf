module "kibana" {
  source = "../../modules/ec2/"
  name = "kibana"
  role = "kibana"
  count    = 1
  ebs_optimized = "false"
  key_pair_name = "${var.key_pair_name}"
  ami           = "${var.ubuntu_ami}"
  instance_type = "${lookup(var.instance_type,"kibana")}"
  subnet_id       = "${element(module.main_vpc.public_subnet_id,0)}"
  associate_public_ip_address = "true"

  volume_size     = "100"
  security_groups = "${aws_security_group.main_public_sg.id}"
}

resource "aws_eip" "kibana_elastic_ip" {
  vpc     = true
  instance = "${element(module.kibana.instance_id, 0)}"
  tags      {
                Name = "${var.name}-kibana-ip"
            }
  lifecycle { create_before_destroy = true }
  depends_on = ["module.kibana"]
}
