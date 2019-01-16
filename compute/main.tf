#----compute/main.tf-----

data "aws_ami" "server_ami" {
  most_recent = true #find the latest AMI owned by Amazon. this can help greatly when going across regions, since IDs can always change

  filter ={
      name = "owner-alias"
      values = ["amazon"]
  }

  filter {
      name = "name"
      values = ["amzn-ami-hvm*-x86_64-gp2"] #We're going to use Amazon Linux as our AMI in this case.
  }

}
resource "aws_key_pair" "tf_auth" {
  key_name = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

data "template_file" "user-init" {
  count = 2
  template = "${file("${path.module}/userdata.tpl")}" #the path.module is a shortcut way to reference the path without having to fully typing it out. this is built into TF natively

  vars {
    firewall_subnets = "${element(var.subnet_ips, count.index)}" #taking elements from the subnet_ips, under the networking module, and outputting it here
  }
}


resource "aws_instance" "tf_server" {
  count = "${var.instance_count}" #we're adding multiple instances so we can have high-avaibility. 
  instance_type = "${var.instance_type}"
  ami = "${data.aws_ami.server_ami.id}"

  tags {
    Name = "tf_server-${count.index +1}" #So we start at number 1, instead of 0 -- since 0 can be used as a value in coding
  }

  key_name = "${aws_key_pair.tf_auth.id}" #It's best to reference other resources, so it makes things a bit more flexible
  vpc_security_group_ids = ["${var.security_group}"]
  subnet_id = "${element(var.subnets, count.index)}" #Pull one of the elements fro the security groups list and assign it a value 
  user_data = "${data.template_file.user-init.*.rendered[count.index]}" #Create a new template file for each individual instance. 
}