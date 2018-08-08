// Create VPC peering between dev and prod
resource "aws_vpc_peering_connection" "vpc-peering-dev-prod" {
   peer_vpc_id   = "${aws_vpc.prod-vpc.id}"
   vpc_id        = "${aws_vpc.dev-vpc.id}"
   auto_accept = true

   tags {
     Name = "vpc-peering-dev-prod"
   }

 }