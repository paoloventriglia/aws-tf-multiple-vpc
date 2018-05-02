// Provision Prod VPC with cidr block of 10.200.0.0/16
resource "aws_vpc" "prod-vpc" {
  cidr_block       = "10.200.0.0/16"


  tags {
    Name = "prod-vpc"
  }
}