variable "vpc_cidr" {}
variable "region" { default = "us-east-1" }
variable "vpc_name" { default="mstackx" }
variable "az" {	type = "list" default = ["us-east-1a","us-east-1b"]}
variable "private_subnet_cidrs" { type = "list" default=[] }
variable "public_subnet_cidrs" { type = "list" default=[] }
variable "key_pair_name" { default = "mstackx" }
variable "whitelist_ips" { type = "list" default=[] }
variable "bastion_ami"  { default = "ami-026c8acd92718196b" }
variable "ubuntu_ami"  { default = "ami-026c8acd92718196b" }
variable "name"  {default = "mstackx"}
variable "ubuntu16_ami"  { default = "ami-0cfee17793b08a293" }


variable "instance_type" {
  type = "map"

  default = {
        bastion        = "t2.micro"
        elasticsearch  = "t2.micro"
        kibana         = "t2.micro"
        jenkins        = "t2.micro"
        kube-master    = "t2.medium"
        kube-node      = "t2.medium"

  }

}
