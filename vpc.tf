module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.vpc_name}"
  cidr = "${var.vpc_main_cidr}"

  azs             = "${var.vpc_azs}"
  private_subnets = "${var.vpc_private_subnets}"
  public_subnets  = "${var.vpc_public_subnets}"


  enable_nat_gateway = true
  enable_vpn_gateway = false

    reuse_nat_ips       = true                      # <= Skip creation of EIPs for the NAT Gateways
  external_nat_ip_ids = ["${aws_eip.nat.*.id}"]   # <= IPs specified here as input to the module

  tags = {
    terraform = "true"
    environment = "${var.environment_tag}"
    department = "${var.department_tag}"
    company  = "${var.company_tag}"
  }
}

resource "aws_eip" "nat" {
   
   count = "${var.eip_cnt}"
   
   vpc = true

}


