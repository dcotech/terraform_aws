#---compute/variables.tf----
variable "key_name" {}

variable "public_key_path" {}

variable "subnet_ips" {
  type = "list"
}

variable "instance_count" {}

variable "instance_type" {}

variable "security_group" {}

variable "subnets" {
  type = "list"
} #This is the AWS-specified ID of the subnets. This doesn't contain the IP addresses




