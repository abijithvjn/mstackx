##### Create VPC ######
resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags      {
		Name = "${var.name}"
	    }
  lifecycle { create_before_destroy = true }
  }


  ###### Create private subnets ######

  resource "aws_subnet" "private_subnet" {
    vpc_id            = "${aws_vpc.vpc.id}"
    count             = "${length(var.private_subnet_cidrs)}"
    cidr_block        = "${element(var.private_subnet_cidrs, count.index)}"
    availability_zone = "${element(var.az, count.index)}"

    tags      {
  		Name = "${var.name}-private-${element(var.az, count.index)}"
  	    }
    lifecycle {
  	      create_before_destroy = true
                ignore_changes = [ "tags" ]
  	    }
  }

  ###### Create public subnets ######

  resource "aws_subnet" "public_subnet" {
  vpc_id            = "${aws_vpc.vpc.id}"
  count             = "${length(var.public_subnet_cidrs)}"
  cidr_block        = "${element(var.public_subnet_cidrs, count.index)}"
  availability_zone = "${element(var.az, count.index)}"

  tags      {
		Name = "${var.name}-public-${element(var.az, count.index)}"
	    }
  lifecycle {
		create_before_destroy = true
		ignore_changes = [ "tags" ]
	    }
}



##### Create NAT gateway #####
resource "aws_eip" "nat_elastic_ip" {
  vpc     = true
  tags      {
                Name = "${var.name}-nat-ip"
            }

  lifecycle { create_before_destroy = true }
}


resource "aws_nat_gateway" "nat_gw" {
  allocation_id = "${aws_eip.nat_elastic_ip.id}"
  subnet_id     = "${element(aws_subnet.public_subnet.*.id, 0)}"

  tags = {
    Name = "${var.name}-nat-gw"
  }

  depends_on = ["aws_eip.nat_elastic_ip"]

  lifecycle { create_before_destroy = true }
}



##### Create Internet gateway #####

resource "aws_internet_gateway" "internet_gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name = "${var.name}-internet-gw"
  }

  lifecycle { create_before_destroy = true }
}

##### Create private route tables #####

resource "aws_route_table" "private_rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags      {
		Name = "${var.name}-private-rt"
	    }
  lifecycle { create_before_destroy = true }
}


resource "aws_route" "for_nat_gateway" {
    route_table_id         = "${aws_route_table.private_rt.id}"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = "${aws_nat_gateway.nat_gw.id}"

    depends_on             = ["aws_nat_gateway.nat_gw"]
}



resource "aws_route_table_association" "private_rt_association" {
  count          = "${length(var.private_subnet_cidrs)}"
  subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.private_rt.id}"
  lifecycle { create_before_destroy = true }
}



##### Create public route tables #####

resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags      {
		Name = "${var.name}-public-rt"
	    }
  lifecycle { create_before_destroy = true }
}



resource "aws_route" "for_internet_gateway" {
    route_table_id         = "${aws_route_table.public_rt.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = "${aws_internet_gateway.internet_gw.id}"

    depends_on             = ["aws_internet_gateway.internet_gw"]
}


resource "aws_route_table_association" "public_rt_association" {
  count          = "${length(var.public_subnet_cidrs)}"
  subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_rt.id}"
  lifecycle { create_before_destroy = true }
}




##### Bastion instance SG #####
resource "aws_security_group" "main_bastion_sg" {
  name        = "${var.name}-bastion"
  description = "Allow SSH acces to bastion servers"
  vpc_id      = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.whitelist_ips}"]
    description = "whitelisted ips"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-bastion"
  }

}


##### Bastion Instance #####
resource "aws_instance" "bastion" {
  ami                         = "${var.bastion_ami}"
  instance_type               = "${var.bastion_instance_type}"
  disable_api_termination     = "true"
  key_name                    = "${var.key_pair_name}"
  monitoring                  = "false"
  vpc_security_group_ids      = ["${aws_security_group.main_bastion_sg.id}"]
  subnet_id                   = "${element(aws_subnet.public_subnet.*.id, 0)}"

  root_block_device {
    volume_type               = "gp2"
    volume_size               = "32"
  }

  tags {
    Name         = "${var.name}-bastion"
  }

}


resource "aws_eip" "bastion_elastic_ip" {
  vpc     = true
  instance = "${aws_instance.bastion.id}"
  tags      {
                Name = "${var.name}-bastion-ip"
            }
  lifecycle { create_before_destroy = true }
  depends_on = ["aws_instance.bastion"]
}
