resource "aws_eip" "dev-nat-gw-eip" {
  vpc      = true
}