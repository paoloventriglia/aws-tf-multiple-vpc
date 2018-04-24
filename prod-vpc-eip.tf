resource "aws_eip" "prod-nat-gw-eip" {
  vpc      = true
}