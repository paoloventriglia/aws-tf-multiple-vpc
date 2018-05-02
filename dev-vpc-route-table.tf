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

# Create route for Dev private subnet
resource "aws_route_table" "dev-priv-route" {
  vpc_id = "${aws_vpc.dev-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.dev-nat-gw.id}"
  }

  route {
    cidr_block = "${aws_vpc.prod-vpc.cidr_block}"
    nat_gateway_id = "${aws_vpc_peering_connection.vpc-peering-dev-prod.id}"
  }

  tags {
    Name = "dev-priv-route"
  }
}

# Associate Dev public subnet route with Dev public subnet
resource "aws_route_table_association" "dev-sub-route-pub-ass" {
  subnet_id = "${aws_subnet.dev-pub-subnet.id}"
  route_table_id = "${aws_route_table.dev-pub-route.id}"

  tags {
    Name = "dev-sub-route-pub-ass"
  }
}

# Associate Dev private subnet route with Dev private subnet
resource "aws_route_table_association" "dev-sub-route-priv-ass" {
  subnet_id      = "${aws_subnet.dev-priv-subnet.id}"
  route_table_id = "${aws_route_table.dev-priv-route.id}"

  tags {
    Name = "dev-sub-route-priv-ass"
  }
}