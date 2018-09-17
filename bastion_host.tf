resource "null_resource" "key_gen" {
  provisioner "local-exec" {
    command = "ssh-keygen -q -f aws_terraform -C aws_terraform_ssh_key -N '' | echo 0''"
    working_dir = "./keys"
  }
}

locals {
  pub_key = "${file("./keys/aws_terraform.pub")}"
}

resource "aws_key_pair" "bastion_host_key" {
  key_name   = "${format("DOCS_TEAM_%s",var.account_alias)}"
  public_key = "${local.pub_key}"
}



data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}



module "ec2" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                        = "${format("BastionHost-%s",var.account_alias)}"
  ami                         = "${data.aws_ami.amazon_linux.id}"
  instance_type               =  "${var.bastion_instance_type}"
  subnet_id                   = "${element(module.vpc.public_subnets, 0)}"
  vpc_security_group_ids      = ["${module.security_group.this_security_group_id}"]
  key_name = "${aws_key_pair.bastion_host_key.key_name}"
  associate_public_ip_address = true
  tags = {
    environment = "${var.environment_tag}"
    company     = "${var.company_tag}"
    department  =  "${var.department_tag}"
  }
}