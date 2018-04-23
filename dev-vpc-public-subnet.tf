# Provision Dev public subnet
resource "aws_subnet" "dev-pub-subnet" {
  vpc_id     = "${aws_vpc.dev-vpc.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags {
    Name = "dev-pub-subnet"
  }
}