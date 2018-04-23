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

# Associate prod route table to internet with prod public subnet
resource "aws_route_table_association" "prod-sub-route-ass" {
  subnet_id      = "${aws_subnet.prod-pub-subnet.id}"
  route_table_id = "${aws_route_table.prod-route-igw.id}"
}