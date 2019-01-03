#---compute/variables.tf----
variable "key_name" {
  default = "tfkey" #this name can be anything. This is just a placeholder
}

variable "public_key_path" {
  default = "/your/public/key/path/goes/here/id_rsa.pub" #usually in your home folder, but your id_rsa.pub file can go anywhere
}