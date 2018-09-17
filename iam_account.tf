module "iam_account" {
  source = "terraform-aws-modules/iam/aws//modules/iam-account"

  account_alias = "${var.account_alias}"

  require_numbers         = false
}
