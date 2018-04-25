# Create security groups
# Internet to bastion on port 22
# Bastion to priv subnet on port 22
# Nat Gateway to internet
# Private subnet to Nat gateway
# Allow 80 and 443 out

resource "aws_security_group" "dev-sec-group-public-inb" {
  name = "Allow_ssh_to_bastion"
  description = "Allow ssh inbound traffic"
  vpc_id = "${aws_vpc.dev-vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "6"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

resource "aws_security_group" "dev-sec-group-public-out" {
  name = "Allow_public_out"
  description = "Allow ssh and https/s outbound traffic"
  vpc_id = "${aws_vpc.dev-vpc.id}"

  egress {
    from_port = 22
    to_port = 22
    protocol = "6"
    cidr_blocks = ["${aws_subnet.dev-priv-subnet.cidr_block}"]
  }

  egress {
    from_port = 80
    to_port = 80
    protocol = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 443
    to_port = 443
    protocol = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "dev-sec-group-private-inb" {
  name = "Allow_ssh_from_bastion"
  description = "Allow ssh inbound traffic"
  vpc_id = "${aws_vpc.dev-vpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "6"
    cidr_blocks = ["${aws_instance.dev-bastion.private_ip}/32"]
  }
}

resource "aws_security_group" "dev-sec-group-private-out" {
  name = "Allow_private_to_internet"
  description = "Allow http/s outbound traffic"
  vpc_id = "${aws_vpc.dev-vpc.id}"

  egress {
    from_port = 80
    to_port = 80
    protocol = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 443
    to_port = 443
    protocol = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }
}