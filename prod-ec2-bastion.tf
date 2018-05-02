// Provision prod bastion in public subnet with Linux AWS AMI
resource "aws_instance" "prod-bastion" {
  ami           = "ami-9cbe9be5"
  instance_type = "t2.micro"
  key_name = "mykeypair"
  subnet_id = "${aws_subnet.prod-pub-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.prod-sec-group-public-subnet.id}"]

  tags {
    Name = "prod-bastion"
  }
}