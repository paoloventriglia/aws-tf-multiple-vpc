// Provision Dev VPC with cidr block of 10.100.0.0/16
resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.100.0.0/16"

  tags {
    Name = "dev-vpc"
  }
}

// Provision Dev VM in private subnet with Linux AWS AMI
resource "aws_instance" "dev-app" {
  ami           = "ami-9cbe9be5"
  instance_type = "t2.micro"
  key_name = "mykeypair"
  subnet_id = "${aws_subnet.dev-priv-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.dev-sec-group-private-subnet.id}"]

  tags {
    Name = "dev-app"
  }
}
// Provision Dev bastion with Linux AWS AMI
resource "aws_instance" "dev-bastion" {
  ami           = "ami-9cbe9be5"
  instance_type = "t2.micro"
  key_name = "mykeypair"
  subnet_id = "${aws_subnet.dev-pub-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.dev-sec-group-public-subnet.id}"]

  tags {
    Name = "dev-bastion"
  }
}
// Provision Dev Elastic IP for NAT GW
resource "aws_eip" "dev-nat-gw-eip" {
  vpc      = true

  tags {
    Name = "dev-nat-gw-eip"
  }
}
// Provision Dev Internet Gateway
resource "aws_internet_gateway" "dev-igw" {
  vpc_id = "${aws_vpc.dev-vpc.id}"

  tags {
    Name = "dev-igw"
  }
}
// Provision Dev NAT Gateway
resource "aws_nat_gateway" "dev-nat-gw" {
  allocation_id = "${aws_eip.dev-nat-gw-eip.id}"
  subnet_id     = "${aws_subnet.dev-pub-subnet.id}"

  tags {
    Name = "dev-nat-gw"
  }
}
// Provision Dev private subnet
resource "aws_subnet" "dev-priv-subnet" {
  vpc_id     = "${aws_vpc.dev-vpc.id}"
  cidr_block = "10.100.1.0/24"

  tags {
    Name = "dev-priv-subnet"
  }
}
// Provision Dev public subnet
resource "aws_subnet" "dev-pub-subnet" {
  vpc_id     = "${aws_vpc.dev-vpc.id}"
  cidr_block = "10.100.2.0/26"
  map_public_ip_on_launch = true

  tags {
    Name = "dev-pub-subnet"
  }
}
// Create route for Dev public subnet
resource "aws_route_table" "dev-pub-route" {
  vpc_id = "${aws_vpc.dev-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.dev-igw.id}"
  }

  tags {
    Name = "dev-pub-route"
  }
}
// Create route for Dev private subnet
resource "aws_route_table" "dev-priv-route" {
  vpc_id = "${aws_vpc.dev-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.dev-nat-gw.id}"
  }

  route {
    cidr_block = "${aws_subnet.prod-priv-subnet.cidr_block}"
    nat_gateway_id = "${aws_vpc_peering_connection.vpc-peering-dev-prod.id}"
  }

  tags {
    Name = "dev-priv-route"
  }
}

// Associate Dev public subnet route with Dev public subnet
resource "aws_route_table_association" "dev-sub-route-pub-ass" {
  subnet_id = "${aws_subnet.dev-pub-subnet.id}"
  route_table_id = "${aws_route_table.dev-pub-route.id}"
}

// Associate Dev private subnet route with Dev private subnet
resource "aws_route_table_association" "dev-sub-route-priv-ass" {
  subnet_id      = "${aws_subnet.dev-priv-subnet.id}"
  route_table_id = "${aws_route_table.dev-priv-route.id}"

}

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
             