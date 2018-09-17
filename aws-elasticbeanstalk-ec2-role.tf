
resource "aws_iam_role" "aws-elasticbeanstalk-ec2-role" {
  name = "aws-elasticbeanstalk-ec2-role"
  description = "Allows EC2 instances to call AWS services on your behalf."
  assume_role_policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
}
EOF
}



resource "aws_iam_role_policy_attachment" "PowerUserAccessAttach" {
  role = "${aws_iam_role.aws-elasticbeanstalk-ec2-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

resource "aws_iam_role_policy_attachment" "AmazonS3FullAccessAttach" {
  role = "${aws_iam_role.aws-elasticbeanstalk-ec2-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ReadOnlyAccessAttach" {
  role = "${aws_iam_role.aws-elasticbeanstalk-ec2-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "AWSElasticBeanstalkWebTierAttach" {
  role = "${aws_iam_role.aws-elasticbeanstalk-ec2-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "AWSElasticBeanstalkMulticontainerDockerAttach" {
  role = "${aws_iam_role.aws-elasticbeanstalk-ec2-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

resource "aws_iam_role_policy_attachment" "AWSElasticBeanstalkWorkerTierAttach" {
  role = "${aws_iam_role.aws-elasticbeanstalk-ec2-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}
