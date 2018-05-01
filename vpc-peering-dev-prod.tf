 resource "aws_vpc_peering_connection" "dev-prod-vpc-peering" {
   peer_vpc_id   = "${aws_vpc.prod-vpc.id}"
   vpc_id        = "${aws_vpc.dev-vpc.id}"
   auto_accept = true

   tags {
     name = "dev-prod-peering"
   }

 }