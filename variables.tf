variable "region" {
  type = string
  default = "us-west-2"
}
variable "vpc_name" {
  type=string
  default="demo-monish-vpc"
}

variable "created_by" {
  type = string
  default = "monish"
}

variable "created_for" {
  type = string
  default = "demo"
}

variable "subnet_cidrs_public" {
  description = "Subnet CIDRs for public subnets"
  default = ["192.168.1.0/24", "192.168.2.0/24"]
  type = list
}

variable "key_name" {
    type = string
    default = "demo-monish-key"
}