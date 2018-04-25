# Create Prod route to the internet
resource "aws_route_table" "prod-route-igw" {
  vpc_id = "${aws_vpc.prod-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.prod-igw.id}"
  }

  tags {
    Name = "prod-route-igw"
  }
}

# Create Prod route private subnet to nat gw
resource "aws_route_table" "prod-route-nat-gw" {
  vpc_id = "${aws_vpc.prod-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.prod-nat-gw.id}"
  }

  tags {
    Name = "prod-route-nat-gw"
  }
}

# Associate Prod route table to internet with Prod public subnet
resource "aws_route_table_association" "prod-sub-route-ass" {
  subnet_id      = "${aws_subnet.prod-pub-subnet.id}"
  route_table_id = "${aws_route_table.prod-route-igw.id}"
}

# Associate Prod route table private subnet to nat gw with Prod private subnet
resource "aws_route_table_association" "prod-sub-route-priv-ass" {
  subnet_id      = "${aws_subnet.prod-priv-subnet.id}"
  route_table_id = "${aws_route_table.prod-route-nat-gw.id}"
}