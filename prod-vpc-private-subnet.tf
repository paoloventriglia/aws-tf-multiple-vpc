# Provision prod private subnet
resource "aws_subnet" "prod-priv-subnet" {
  vpc_id     = "${aws_vpc.prod-vpc.id}"
  cidr_block = "10.0.20.0/24"

  tags {
    Name = "prod-priv-subnet"
  }
}