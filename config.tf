provider "aws" {
  access_key = "AKIAI4XQ3PPASDFPN3SA"
  secret_key = "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"
  region     = "${var.region}"

  assume_role {
    role_arn     = "arn:aws:iam::392692631612:role/OrganizationAccountAccessRole"
  }

}

locals {
  s3backendkey = "${format("accounts_%s/",var.account_alias)}"
}

terraform {
  backend "s3" {
    bucket = "terraform-state-us-east-1-810919534676"
    region = "us-east-1"

  }
}
