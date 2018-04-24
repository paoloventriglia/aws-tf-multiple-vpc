# Provision Dev webserver with Linux AWS AMI
resource "aws_instance" "dev-app" {
  ami           = "ami-9cbe9be5"
  instance_type = "t2.micro"
  key_name = "mykeypair"
  subnet_id = "${aws_subnet.dev-priv-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.dev-sec-group-private-inb.id}","${aws_security_group.dev-sec-group-private-out.id}"]

  tags {
    name = "dev-app"
  }
}
