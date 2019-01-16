provider "aws" {
  region = "${var.aws_region}"
}

#Deploy storage resource
module "storage" {
  source = "./storage"
  project_name = "${var.project_name}"
  
}

#Deploy networking resources

module "networking" {
  source = "./networking"
  vpc_cidr = "${var.vpc_cidr}"
  public_cidrs = "${var.public_cidrs}"
  access_ip = "${var.access_ip}"
  
}

#Deploy Compute Resources

module "compute" {
  source = "./compute"
  instance_count = "${var.instance_count}"
  key_name = "${var.key_name}"
  public_key_path = "${var.public_key_path}"
  instance_type = "${var.server_instance_type}" #the var name space does not matter. only names left of the equal sign have to match the ones in the corresponding module
  subnets = "${module.networking.public_subnets}"
  security_group = "${module.networking.public_sg}"
  subnet_ips = "${module.networking.subnet_ips}"
}