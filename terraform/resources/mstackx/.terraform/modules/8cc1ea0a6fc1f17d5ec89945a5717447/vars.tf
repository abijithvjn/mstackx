variable "name" { }
variable "role" {}
variable "count" { default = 1 }

variable "instance_type" {}
variable "ami" {}
variable "ebs_optimized" { default = "false" }
variable "security_groups" {}
variable "subnet_id" {}

variable "disable_api_termination" { default = "false" }
variable "key_pair_name" {}
variable "monitoring" { default = "false" }
variable "associate_public_ip_address" { default = "false" }

variable "volume_type" { default = "gp2" }
variable "volume_size" { default = "32" }
