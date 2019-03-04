provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_instance" "web" {
  ami = "ami-035be7bafff33b6b6"
  instance_type = "t2.micro"
  key_name = "${var.deployer_key_name}"

  vpc_security_group_ids = [
    "${aws_security_group.web_ssh.id}",
  ]

  tags {
    Name = "ecb"
    language = "go"
    cms = "ponzu"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > public_ip.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install docker -y",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
      "sudo docker run -d -p 80:80 pitakill/ecb"
    ]

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file(var.private_key_path)}"
    }
  }
}

resource "aws_key_pair" "deployer" {
  key_name = "${var.deployer_key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_security_group" "web_ssh" {
  name = "web/ssh rules"
  description = "Allow all ssh/http inbound traffic and Allow all outbound traffic"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress = {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress = {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
