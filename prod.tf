// Provision Prod VPC with cidr block of 10.200.0.0/16
resource "aws_vpc" "prod-vpc" {
  cidr_block       = "10.200.0.0/16"

 tags {
    Name = "prod-vpc"
  }
}

// Provision prod VM in private subnet with Linux AWS AMI
resource "aws_instance" "prod-app" {
  ami           = "ami-9cbe9be5"
  instance_type = "t2.micro"
  key_name = "mykeypair"
  subnet_id = "${aws_subnet.prod-priv-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.prod-sec-group-private-subnet.id}"]

  tags {
    Name = "prod-app"
  }
}

// Provision prod bastion in public subnet with Linux AWS AMI
resource "aws_instance" "prod-bastion" {
  ami           = "ami-9cbe9be5"
  instance_type = "t2.micro"
  key_name = "mykeypair"
  subnet_id = "${aws_subnet.prod-pub-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.prod-sec-group-public-subnet.id}"]

  tags {
    Name = "prod-bastion"
  }
}

// Provision Prod Elastic IP for NAT GW
 resource "aws_eip" "prod-nat-gw-eip" {
  vpc      = true

    tags {
    Name = "prod-nat-gw-eip"
  }
}

// Provision Prod Internet Gateway
resource "aws_internet_gateway" "prod-igw" {
  vpc_id = "${aws_vpc.prod-vpc.id}"

  tags {
    Name = "prod-igw"
  }
}

// Provision prod NAT Gateway
resource "aws_nat_gateway" "prod-nat-gw" {
  allocation_id = "${aws_eip.prod-nat-gw-eip.id}"
  subnet_id     = "${aws_subnet.prod-pub-subnet.id}"

  tags {
    Name = "prod-nat-gw"
  }
}

// Provision prod private subnet
resource "aws_subnet" "prod-priv-subnet" {
  vpc_id     = "${aws_vpc.prod-vpc.id}"
  cidr_block = "10.200.1.0/24"

  tags {
    Name = "prod-priv-subnet"
  }
}

// Provision Prod public subnet
resource "aws_subnet" "prod-pub-subnet" {
  vpc_id     = "${aws_vpc.prod-vpc.id}"
  cidr_block = "10.200.2.0/26"
  map_public_ip_on_launch = true

  tags {
    Name = "prod-pub-subnet"
  }
}

// Create route for prod public subnet
resource "aws_route_table" "prod-pub-route" {
  vpc_id = "${aws_vpc.prod-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.prod-igw.id}"
  }

  tags {
    Name = "prod-pub-route"
  }
}

// Create route for prod private subnet
resource "aws_route_table" "prod-priv-route" {
  vpc_id = "${aws_vpc.prod-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.prod-nat-gw.id}"
  }

  route {
    cidr_block = "${aws_subnet.dev-priv-subnet.cidr_block}"
    nat_gateway_id = "${aws_vpc_peering_connection.vpc-peering-dev-prod.id}"
  }

  tags {
    Name = "prod-priv-route"
  }
}

// Associate prod public subnet route with prod public subnet
resource "aws_route_table_association" "prod-sub-route-pub-ass" {
  subnet_id = "${aws_subnet.prod-pub-subnet.id}"
  route_table_id = "${aws_route_table.prod-pub-route.id}"

}

// Associate prod private subnet route with prod private subnet
resource "aws_route_table_association" "prod-sub-route-priv-ass" {
  subnet_id      = "${aws_subnet.prod-priv-subnet.id}"
  route_table_id = "${aws_route_table.prod-priv-route.id}"

}

// Create security group to allow traffic inbound and outbound to/from public subnet
resource "aws_security_group" "prod-sec-group-public-subnet" {
  name = "prod-sec-group-public-subnet"
  description = "Allow inbound traffic to public subnet"
  vpc_id = "${aws_vpc.prod-vpc.id}"

// Allow inbound ssh access from internet  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "6"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

// Allow outbound ssh access to prod private subnet  
  egress {
    from_port = 22
    to_port = 22
    protocol = "6"
    cidr_blocks = ["${aws_subnet.prod-priv-subnet.cidr_block}"]
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
    Name = "prod-sec-group-public-subnet"
  }
}

// Create security group to allow traffic inbound and outbound to/from private subnet
resource "aws_security_group" "prod-sec-group-private-subnet" {
  name = "prod-sec-group-private-subnet"
  description = "Allow private inbound traffic"
  vpc_id = "${aws_vpc.prod-vpc.id}"

  //  Allow inbound ssh access from public subnet  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "6"
    cidr_blocks = ["${aws_subnet.prod-pub-subnet.cidr_block}"]
  }
  
//  Allow inbound ssh access from prod priv subnet  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "6"
    cidr_blocks = ["${aws_subnet.dev-priv-subnet.cidr_block}"]
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
  

  tags {
    Name = "prod-sec-group-private-subnet"
  }
}

