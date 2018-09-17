
//resource "aws_iam_role" "OrganizationAccountAccessRole" {
//  name = "OrganizationAccountAccessRole"
//  description = "Role That allows AssumeRole into Account"
//  assume_role_policy = <<EOF
//{
//  "Version": "2012-10-17",
//  "Statement": [
//    {
//      "Action": "sts:AssumeRole",
//      "Principal": {
//        "AWS": "arn:aws:iam::810919534676:root"
//      },
//      "Effect": "Allow",
//      "Sid": ""
//    }
//  ]
//}
//EOF
//}

resource "aws_iam_policy" "grant_s3_access_policy" {
  name        = "grant_dockercfg_s3_bucket_access"
  path        = "/"
  description = "Grants access to the Docker Repo Config Policy."

  policy = <<EOF
{
  "Version": "2012-10-17",
    "Statement":
    [
      {
        "Sid": "Example",
        "Effect": "Allow",
        "Action": [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetObject"
        ],
        "Resource": [
          "arn:aws:s3:::dockerrepo-starz-aws00"
        ]
      }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "OrganizationAccountAccessAttach" {
  role       = "OrganizationAccountAccessRole"
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}


resource "aws_iam_role_policy_attachment" "grant_s3_access_policy_attach" {
  role       =   "OrganizationAccountAccessRole"
  policy_arn = "${aws_iam_policy.grant_s3_access_policy.arn}"
}

