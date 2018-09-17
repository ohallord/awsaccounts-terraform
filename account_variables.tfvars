
region = "eu-west-2"

access_key = ""
secret_key = ""


account_alias = "starzplayukprod"
environment_tag = "production"
company_tag  = "starz"
department_tag = "415-web-starzplayuk"
vpc_name =  "Default VPC from Account Organizations"
vpc_main_cidr = "10.0.0.0/16"
vpc_azs = [
     "eu-west-2a",
     "eu-west-2b",
     "eu-west-2c"
]

vpc_private_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
    ]

vpc_public_subnets = [
  "10.0.101.0/24",
  "10.0.102.0/24",
  "10.0.103.0/24"
]

bastion_instance_type = "t2.medium"

eip_cnt = 3






