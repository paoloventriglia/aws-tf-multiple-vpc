# Provision VPC with cidr block of 10.0.0.0/16
resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"

  tags {
    Name = "myvpc"
  }
}

# Provision public subnet
resource "aws_subnet" "mysubnet" {
  vpc_id     = "${aws_vpc.myvpc.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags {
    Name = "mysubnet"
  }
}

# Provision Internet Gateway
resource "aws_internet_gateway" "myig" {
  vpc_id = "${aws_vpc.myvpc.id}"

  tags {
    Name = "myig"
  }
}

# Create route to the internet
resource "aws_route_table" "myroute" {
  vpc_id = "${aws_vpc.myvpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.myig.id}"
  }

  tags {
    Name = "myroute"
  }
}

# Associate route table to internet with public subnet
resource "aws_route_table_association" "sub_route_a" {
  subnet_id      = "${aws_subnet.mysubnet.id}"
  route_table_id = "${aws_route_table.myroute.id}"
}


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


