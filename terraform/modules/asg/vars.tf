variable "region" { default = "us-east-1" }
variable "name" {}
variable "ami" {}
variable "instance_type" {}
variable "min_size" { default = "1" }
variable "max_size" { default = "5" }
variable "desired_capacity" { default = "1" }
variable "key_pair_name" {}
variable "ebs_optimized" { default = "false" }
variable "volume_type" { default = "gp2" }
variable "volume_size" { default = "20" }
variable "root_volume_delete_on_termination" { default = "true" }
variable "security_groups" {}
variable "asg_subnets" {}
variable "user_data_template" {}
variable "associate_public_ip_address" { default = "false" }
variable "iam_instance_profile" { default = "ec2-default-profile"}
variable "tg_port" {}
variable  "lb_vpc_id" {}
variable "health_check_port" {}
variable "health_check_interval" {}
variable "health_check_path" {}
variable "health_check_matcher" {}
variable "lb_security_groups" {}
variable "lb_subnets" {}
variable "app_name" {}
