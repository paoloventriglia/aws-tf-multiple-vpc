# aws-tf-multiple-vpc
This Terraform code will create 2 VPCs with a peering connection plus 4 servers, 2 in each VPC. 
Two servers are bastion servers accessible from the internet and 2 servers are in a private subnet. 

You need to provide a terraform.tfvars file containing your Access and Secret keys, then run terraform plan -out plan.tfplan,
if it all goes well run terraform apply plan.tfplan
