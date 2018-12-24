#---networking/variables.tf---
variable "vpc_cidr" {
  default = "10.123.0.0/16"
}

variable "public_cidrs" {
  default = [
      "10.124.1.0/24",
      "10.124.2.0/24"
  ]
}

variable "localip" {
  default = "0.0.0.0/0"
}
