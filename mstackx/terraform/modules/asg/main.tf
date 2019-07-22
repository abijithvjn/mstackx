## Create user-data template
data "template_file" "user_data_file" {
  template = "${file("${path.module}/user_data_templates/${var.user_data_template}.tpl")}"

  vars {
    region           = "${var.region}"
  }
}


## Create Launch Configuration for application
resource "aws_launch_configuration" "aws_launch_config" {
  name_prefix          = "${var.name}-lc"
  image_id             = "${var.ami}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_pair_name}"
  iam_instance_profile = "${var.iam_instance_profile}"
  ebs_optimized        = "${var.ebs_optimized}"


  root_block_device {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.volume_size}"
    delete_on_termination = "${var.root_volume_delete_on_termination}"
  }

  security_groups = ["${split(",",var.security_groups)}"]
  lifecycle {
    create_before_destroy = true
  }
}


## Create Autoscaling group
resource "aws_autoscaling_group" "aws_asg" {
  name                 = "${var.name}-asg"
  launch_configuration = "${aws_launch_configuration.aws_launch_config.name}"

  health_check_type         = "EC2"
  health_check_grace_period = 60
  wait_for_capacity_timeout = 0
  force_delete              = false

  vpc_zone_identifier  = ["${split(",",var.asg_subnets)}"]

  min_size             = "${var.min_size}"
  max_size             = "${var.max_size}"
  desired_capacity     = "${var.desired_capacity}"

  lifecycle {
    create_before_destroy = true
    ignore_changes = [ "min_size","max_size","desired_capacity" ]
  }

  tags = [
      {
        key   = "Name"
        value = "${var.name}-asg"
        propagate_at_launch = true
      }
  ]
}
