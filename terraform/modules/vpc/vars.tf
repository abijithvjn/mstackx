variable "name" { }
variable "vpc_cidr" { }
variable "az" { type = "list" }
variable "private_subnet_cidrs" { type = "list" }
variable "public_subnet_cidrs" { type = "list" }
variable "whitelist_ips" { type = "list"  default = []}
variable "key_pair_name" { default = "mstackx" }
variable "bastion_ami" { default = "ami-026c8acd92718196b" }
variable "bastion_instance_type" { default = "t2.micro" }
