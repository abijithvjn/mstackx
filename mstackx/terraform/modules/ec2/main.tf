resource "aws_instance" "app_ec2" {
  count                       = "${var.count}"
  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  ebs_optimized               = "${var.ebs_optimized}"
  disable_api_termination     = "${var.disable_api_termination}"
  key_name                    = "${var.key_pair_name}"
  monitoring                  = "${var.monitoring}"
  vpc_security_group_ids      = ["${split(",",var.security_groups)}"]
  subnet_id                   = "${element(split(",", var.subnet_id), count.index)}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  root_block_device {
    volume_type               = "${var.volume_type}"
    volume_size               = "${var.volume_size}"
  }

  tags {
    Name         = "${var.name}-${count.index + 1}"
    Role  = "${var.role}"
  }
  }
