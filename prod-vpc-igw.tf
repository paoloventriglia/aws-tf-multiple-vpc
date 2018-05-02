// Provision Prod Internet Gateway
resource "aws_internet_gateway" "prod-igw" {
  vpc_id = "${aws_vpc.prod-vpc.id}"

  tags {
    Name = "prod-igw"
  }
}