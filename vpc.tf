




# Create security group to allow SSH in and HTTP/S out
resource "aws_security_group" "mysg" {
  name = "Allow_ssh_myip"
  description = "Allow ssh inbound traffic"
  vpc_id = "${aws_vpc.myvpc.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "6"
    cidr_blocks = ["myipaddress"]
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

# Provision 1 public instance with AWS AMI
resource "aws_instance" "myvm" {
  ami           = "ami-d834aba1"
  instance_type = "t2.micro"
  key_name = "mykeypair"
  subnet_id = "${aws_subnet.mysubnet.id}"
  vpc_security_group_ids = ["${aws_security_group.mysg.id}"]
}


