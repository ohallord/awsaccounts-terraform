module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "Bastion Host Sec Group"
  description = "Enables SSH Access to Bastion Hosts"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_cidr_blocks = ["174.46.221.17/32"]
  ingress_rules       = ["ssh-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
  tags = {
    environment = "${var.environment_tag}"
    company     = "${var.company_tag}"
    department  =  "${var.department_tag}"
  }
}