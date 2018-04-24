# Provision prod webserver with Linux AWS AMI
resource "aws_instance" "prod-app" {
  ami           = "ami-9cbe9be5"
  instance_type = "t2.micro"
  key_name = "mykeypair"
  subnet_id = "${aws_subnet.prod-priv-subnet}"
  vpc_security_group_ids = ["${aws_security_group.prod-sec-group-private-inb}","${aws_security_group.prod-sec-group-private-out}"]

  tags {
    name = prod-app
  }
}