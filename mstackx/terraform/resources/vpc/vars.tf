variable "vpc_cidr" {}
variable "region" { default = "us-east-1" }
variable "vpc_name" { default="mstackx" }
variable "az" {	type = "list" default = ["us-east-1a","us-east-1b"]}
variable "private_subnet_cidrs" { type = "list" default=[] }
variable "public_subnet_cidrs" { type = "list" default=[] }
variable "key_pair_name" { default = "mstackx" }
variable "whitelist_ips" { type = "list" default=[] }
variable "bastion_ami"  { default = "ami-026c8acd92718196b" }
