// Provision Prod public subnet
resource "aws_subnet" "prod-pub-subnet" {
  vpc_id     = "${aws_vpc.prod-vpc.id}"
  cidr_block = "10.200.2.0/26"
  map_public_ip_on_launch = true

  tags {
    Name = "prod-pub-subnet"
  }
}