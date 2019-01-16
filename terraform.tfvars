aws_region = "us-west-2"
project_name = "dco-terraform"
vpc_cidr = "10.123.0.0/16"
public_cidrs = [
    "10.123.1.0/24",
    "10.123.2.0/24"
]
access_ip = "0.0.0.0/0"
key_name = "tf_key"
public_key_path = "/your/public/key/goes/here/id_rsa.pub" #usually in your home folder, but your id_rsa.pub file can go anywhere
server_instance_type = "t2.micro"
instance_count = 2