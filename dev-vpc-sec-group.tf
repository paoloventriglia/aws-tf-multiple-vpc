# Create security group to allow SSH in and HTTP/S out
resource "aws_security_group" "dev-sec-group-bastion-inb" {
  name = "Allow_ssh_to_bastion"
  description = "Allow ssh inbound traffic"
  vpc_id = "${aws_vpc.dev-vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "6"
    cidr_blocks = [
      "*******"]
  }
}

resource "aws_security_group" "dev-sec-group-bastion-out" {
  name = "Allow_ssh_to_priv"
  description = "Allow ssh inbound traffic"
  vpc_id = "${aws_vpc.dev-vpc.id}"

    egress {
    from_port = 22
    to_port = 22
    protocol = "6"
    cidr_blocks = "${aws_subnet.dev-pub-subnet.cidr_block}"
  }
}

    egress {
    from_port = 443
    to_port = 443
    protocol = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

    egress {
    from_port = 80
    to_port = 80
    protocol = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }
}