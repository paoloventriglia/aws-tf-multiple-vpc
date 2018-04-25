# Create Dev route public subnet to internet
resource "aws_route_table" "dev-route-igw" {
  vpc_id = "${aws_vpc.dev-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.dev-igw.id}"
  }

  tags {
    Name = "dev-route-igw"
  }
}

# Create Dev route private subnet to nat gw
resource "aws_route_table" "dev-route-nat-gw" {
  vpc_id = "${aws_vpc.dev-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.dev-nat-gw.id}"
  }

  tags {
    Name = "dev-route-nat-gw"
  }
}

# Associate Dev route table public subnet   to internet with Dev public subnet
resource "aws_route_table_association" "dev-sub-route-pub-ass" {
  subnet_id = "${aws_subnet.dev-pub-subnet.id}"
  route_table_id = "${aws_route_table.dev-route-igw.id}"
}

# Associate Dev route table private subnet to nat gw with Dev private subnet
resource "aws_route_table_association" "dev-sub-route-priv-ass" {
  subnet_id      = "${aws_subnet.dev-priv-subnet.id}"
  route_table_id = "${aws_route_table.dev-route-nat-gw.id}"
}