# Provision Dev private subnet
resource "aws_subnet" "dev-priv-subnet" {
  vpc_id     = "${aws_vpc.dev-vpc.id}"
  cidr_block = "10.100.1.0/24"

  tags {
    Name = "dev-priv-subnet"
  }
}