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