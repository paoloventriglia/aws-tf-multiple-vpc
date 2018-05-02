// Provision Dev VPC with cidr block of 10.100.0.0/16
resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.100.0.0/16"

  tags {
    Name = "dev-vpc"
  }
}