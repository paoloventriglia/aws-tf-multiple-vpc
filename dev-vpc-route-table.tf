# Create Dev route to the internet
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

# Associate Dev route table to internet with Dev public subnet
resource "aws_route_table_association" "dev-sub-route-ass" {
  subnet_id      = "${aws_subnet.dev-pub-subnet.id}"
  route_table_id = "${aws_route_table.dev-route-igw.id}"
}