// Provision Prod Elastic IP for NAT GW
 resource "aws_eip" "prod-nat-gw-eip" {
  vpc      = true
}