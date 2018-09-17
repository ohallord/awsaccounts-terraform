

locals  {
  bucketname = "${format("%s-%s-%s", var.account_alias, var.region , data.aws_caller_identity.current.account_id)}"
  bucket_resource = "${format("arn:aws:s3:::%s-%s-%s/*", var.account_alias, var.region , data.aws_caller_identity.current.account_id)}"

}


resource "aws_s3_bucket" "defualt_account_region_bucket" {

  bucket = "${local.bucketname}"
  acl    = "private"

  tags {
    Name        = "${local.bucketname}"
    environment = "${var.environment_tag}"
    company     = "${var.company_tag}"
    department  =  "${var.department_tag}"
  }

  versioning {
    enabled = true
  }

  lifecycle_rule {
    prefix  = "/"
    enabled = true

    noncurrent_version_transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    noncurrent_version_transition {
      days          = 365
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      days = 730
    }
  }



  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "Policy1517523056107",
    "Statement": [
        {
            "Sid": "Stmt1517523050621",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "${aws_iam_role.aws-elasticbeanstalk-ec2-role.arn}",
                    "arn:aws:iam::392692631612:role/OrganizationAccountAccessRole",
                    "${aws_iam_role.BambooDeployCrossAccountRole.arn}"
                ]
            },
            "Action": [
                "s3:PutObject",
                "s3:GetObject"
            ],

            "Resource" : "${local.bucket_resource}"
        }
    ]
}
EOF

}

