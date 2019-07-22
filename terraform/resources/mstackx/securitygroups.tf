##### General SG for servers
resource "aws_security_group" "main_internal_sg" {
  name        = "${var.vpc_name}-internal"
  description = "Allow all internal traffic within VPC"
  vpc_id      = "${module.main_vpc.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = ["${module.main_vpc.sg_bastion}"]
    description = "allow SSH from bastion servers"
  }


  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.vpc_name}-internal"
  }

}

##### For public load balancers

resource "aws_security_group" "main_public_sg" {
  name        = "${var.vpc_name}-public"
  description = "Allow all inbound traffic globally"
  vpc_id      = "${module.main_vpc.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
  }


  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.vpc_name}-public"
  }

}

##### For kibana instances
resource "aws_security_group" "kibana_sg" {
  name        = "${var.vpc_name}-kibana"
  description = "SG for the kibana"
  vpc_id      = "${module.main_vpc.vpc_id}"

  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.vpc_name}-kibana"
  }
}
