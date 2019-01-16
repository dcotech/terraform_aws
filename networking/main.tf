#---networking/main.tf---

data "aws_availability_zones" "available" {
  
}

#Create the VPC
resource "aws_vpc" "tf_vpc" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support = true

  #Labels/tags in the namespace of the VPC
  tags {
      Name = "tf_vpc"
  }
}

#Create the internet gateway
resource "aws_internet_gateway" "tf_internet_gateway" {
    vpc_id = "${aws_vpc.tf_vpc.id}"

    #Like before, this is for label/tagging in the namspace
    tags {
        Name = "tf_igw"
    }
  
}

#Create the routing table so the VPC has a private and public network
resource "aws_route_table" "tf_public_rt" {
    vpc_id = "${aws_vpc.tf_vpc.id}"

    #public route table 
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.tf_internet_gateway.id}"
    } 

    tags {
        Name = "tf_public"
    } 
}

#This is for the private route table. Unless explicitly associated with the public, AWS resources in the VPC will default to the private network
resource "aws_default_route_table" "tf_private_rt" {
    default_route_table_id = "${aws_vpc.tf_vpc.default_route_table_id}"

    tags {
        Name = "tf_private"
    }
}

#Subnets

resource "aws_subnet" "tf_public_subnet" {
    #This was created to avoid repeatition. The simpler way is to make two public aws_subnet resources with different names, variables, etc
    count = 2 #count up to two
    vpc_id = "${aws_vpc.tf_vpc.id}"
    cidr_block = "${var.public_cidrs[count.index]}"
    map_public_ip_on_launch = true
    availability_zone = "${data.aws_availability_zones.available.names[count.index]}"

    tags {
        Name = "tf_public_${count.index + 1}" #This is start at the number 1, since index start at 0
    }
}

resource "aws_route_table_association" "tf_public_association" {
  count = "${aws_subnet.tf_public_subnet.count}"
  subnet_id = "${aws_subnet.tf_public_subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.tf_public_rt.id}"
}

#Secure the environment. This isn't necessarily the best practice -- since an organization
#would use additional hardning such as RBAC, 2-factor authentication, etc
resource "aws_security_group" "tf_public_sg" {
  name = "tf_public_sg"
  description = "Used for access to public instances"
  vpc_id = "${aws_vpc.tf_vpc.id}"

  #SSH -- inbound traffic
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["${var.access_ip}"] #if words are plural, in the TF world, much of the time it's a list
  }

   #HTTP -- inbound traffic
  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["${var.access_ip}"]
  }

  egress {
      from_port = 0 #allow all ports
      to_port = 0 
      protocol = "-1" #allow all protocols: UDP, TCP, etc
      cidr_blocks = ["0.0.0.0/0"]
  }
}

