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
    default_route_table_id = "${aws_vpc.tf_vpc.default_route_table_id.id}"

    tags {
        Name = "tf_private"
    }
}
