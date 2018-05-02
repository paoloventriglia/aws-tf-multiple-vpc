// Create security group to allow traffic inbound and outbound tp/from public subnet
resource "aws_security_group" "dev-sec-group-public-subnet" {
  name = "dev-sec-group-public-subnet"
  description = "Allow inbound traffic to public subnet"
  vpc_id = "${aws_vpc.dev-vpc.id}"

// Allow inbound ssh access from internet
  ingress {
    from_port = 22
    to_port = 22
    protocol = "6"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

// Allow outbound ssh access to dev private subnet
  egress {
    from_port = 22
    to_port = 22
    protocol = "6"
    cidr_blocks = ["${aws_subnet.dev-priv-subnet.cidr_block}"]
  }


// Allow outbound http access to internet
  egress {
    from_port = 80
    to_port = 80
    protocol = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

// Allow outbound https access to internet
  egress {
    from_port = 443
    to_port = 443
    protocol = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "dev-sec-group-public-subnet"
  }
}

resource "aws_security_group" "dev-sec-group-private-subnet" {
  name = "dev-sec-group-private-subnet"
  description = "Allow private inbound traffic"
  vpc_id = "${aws_vpc.dev-vpc.id}"

//  Allow inbound ssh access from public subnet
  ingress {
    from_port = 22
    to_port = 22
    protocol = "6"
    cidr_blocks = ["${aws_subnet.dev-pub-subnet.cidr_block}"]
  }

//  Allow outbound http access to internet
  egress {
    from_port = 80
    to_port = 80
    protocol = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

//  Allow outbound https access to internet
  egress {
    from_port = 443
    to_port = 443
    protocol = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

//  Allow outbound ssh access to prod priv subnet
  egress {
    from_port = 22
    to_port = 22
    protocol = "6"
    cidr_blocks = ["${aws_subnet.prod-priv-subnet.cidr_block}"]
  }

  tags {
    Name = "dev-sec-group-private-subnet"
  }
}
