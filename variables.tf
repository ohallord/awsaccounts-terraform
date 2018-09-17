
variable "region" {
  default = "us-east-1"
}

variable "access_key" {
  default = ""
}

variable "secret_key" {
  default = ""
}

variable "account_alias" {
  default = "danoh-aws"
}

variable "environment_tag" {
  default = "development"
}

variable "company_tag" {
  default = "starz"
}

variable "department_tag" {
  default = "415-web-starzplayuk"
}

variable "vpc_name" {
  default =  "Default VPC from Account Organizations"
}
variable "vpc_main_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_azs" {
  type = "list"
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "vpc_private_subnets" {
  type = "list"
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "vpc_public_subnets" {
  type = "list"
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "eip_cnt" {
  default = 3
}

variable "bastion_instance_type" {
  type = "string"
}
