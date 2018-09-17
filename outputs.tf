#-------------------------------------------------------#
#    Get Account ID                                     #
#-------------------------------------------------------#

data "aws_caller_identity" "current" {}

output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

//locals {
//  account_alias = "${module.iam_account.account_alias}"
//
//}

output "account_alias" {
  value = "${var.account_alias}"
}

#-------------------------------------------------------#
#    VPC  Outputs                                       #
#-------------------------------------------------------#

# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = "${module.vpc.vpc_id}"
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = ["${module.vpc.private_subnets}"]
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = ["${module.vpc.public_subnets}"]
}



# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = ["${module.vpc.nat_public_ips}"]
}


#-------------------------------------------------------#
#    Role Outputs                                       #
#-------------------------------------------------------#
#Elastic beanstalk Role
output "aws-elasticbeanstalk-ec2-role" {
  description = "ARN of Elastic Beanstalk ec2 role"
  value       = "${element(concat(aws_iam_role.aws-elasticbeanstalk-ec2-role.*.arn, list()), 0)}"
}

output "aws-elasticbeanstalk-ec2-name" {
  description = "Name of aws-elasticbeanstalk-ec2 IAM role"
  value       = "${element(concat(aws_iam_role.aws-elasticbeanstalk-ec2-role.*.name, list()), 0)}"
}

#Bamboo Deployment Role
output "BambooDeployCrossAccountRole" {
  description = "ARN of Bamboo Deploy Cross account role"
  value       = "${element(concat(aws_iam_role.BambooDeployCrossAccountRole.*.arn, list()), 0)}"
}

output "BambooDeployCrossAccountName" {
  description = "Name BambooDeployCrossAccountName IAM role"
  value       = "${element(concat(aws_iam_role.BambooDeployCrossAccountRole.*.name, list()), 0)}"
}

//#Organizations Account Role
//output "OrganizationAccountAccessRole" {
//  description = "ARN of Organization Account Access Role  account role"
//  value       = "${element(concat(aws_iam_role.OrganizationAccountAccessRole.*.arn, list()), 0)}"
//}
//
//output "OrganizationAccountAccessName" {
//  description = "Name Organization Account Access Role IAM role"
//  value       = "${element(concat(aws_iam_role.OrganizationAccountAccessRole.*.name, list()), 0)}"
//}

#Organizations Account Role
output "aws-elasticbeanstalk-service-role" {
  description = "ARN of Beanstalk Service role  account role"
  value       = "${element(concat(aws_iam_role.aws-elasticbeanstalk-service-role.*.arn, list()), 0)}"
}

output "aws-elasticbeanstalk-service-name" {
  description = "Name Beanstalk Service role IAM role"
  value       = "${element(concat(aws_iam_role.aws-elasticbeanstalk-service-role.*.name, list()), 0)}"
}

# EC2 Outputs

output "KeyPairName" {
  value = "${aws_key_pair.bastion_host_key.key_name}"
}

output "id" {
  description = "List of IDs of instances"
  value       = ["${module.ec2.id}"]
}

output "public_dns" {
  description = "List of public DNS names assigned to the instances"
  value       = ["${module.ec2.public_dns}"]
}

//output "instance_id" {
//  description = "EC2 instance ID"
//  value       = "${module.ec2.id[0]}"
//}
//
//output "instance_public_dns" {
//  description = "Public DNS name assigned to the EC2 instance"
//  value       = "${module.ec2.public_dns[0]}"
//}