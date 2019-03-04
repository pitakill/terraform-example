variable "aws_region" {
  default = "us-east-1"
}

variable "private_key_path" {
  default = "~/.ssh/id_rsa"
}

variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "deployer_key_name" {
  default = "pitakill's key"
}
