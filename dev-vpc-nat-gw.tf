resource "aws_nat_gateway" "dev-nat-gw" {
  allocation_id = "${aws_eip.dev-nat-gw-eip.id}"
  subnet_id     = "${aws_subnet.dev-pub-subnet.id}"

  tags {
    Name = "dev-nat-gw"
  }
}