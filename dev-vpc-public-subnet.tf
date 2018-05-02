// Provision Dev public subnet
resource "aws_subnet" "dev-pub-subnet" {
  vpc_id     = "${aws_vpc.dev-vpc.id}"
  cidr_block = "10.100.2.0/26"
  map_public_ip_on_launch = true

  tags {
    Name = "dev-pub-subnet"
  }
}