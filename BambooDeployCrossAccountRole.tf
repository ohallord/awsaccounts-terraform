
resource "aws_iam_role" "BambooDeployCrossAccountRole" {
  name = "BambooDeployCrossAccountRole"
  description = "Role to allow Bamboo to deploy code to."
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "AWS": "arn:aws:iam::810919534676:root"
          },
          "Effect": "Allow",
          "Sid": ""
        }
    ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "grant_s3_access_policy_attach_bamboo" {
  role       =   "${aws_iam_role.BambooDeployCrossAccountRole.name}"
  policy_arn = "${aws_iam_policy.grant_s3_access_policy.arn}"
}


resource "aws_iam_role_policy_attachment" "BambooDeployCrossAccountAttach" {
  role       = "${aws_iam_role.BambooDeployCrossAccountRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

