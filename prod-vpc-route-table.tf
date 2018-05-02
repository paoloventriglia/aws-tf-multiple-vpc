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
    cidr_block = "${aws_vpc.dev-vpc.cidr_block}"
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