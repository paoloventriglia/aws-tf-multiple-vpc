// Provision prod NAT Gateway
resource "aws_nat_gateway" "prod-nat-gw" {
  allocation_id = "${aws_eip.prod-nat-gw-eip.id}"
  subnet_id     = "${aws_subnet.prod-pub-subnet.id}"

  tags {
    Name = "prod-nat-gw"
  }
}