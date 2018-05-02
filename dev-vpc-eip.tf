// Provision Dev Elastic IP for NAT GW
resource "aws_eip" "dev-nat-gw-eip" {
  vpc      = true

  tags {
    Name = "dev-nat-gw-eip"
  }
}