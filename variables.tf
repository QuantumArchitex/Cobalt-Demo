variable "tenant" {
  type = string
}

variable "domain" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "public_key_path" {
  type = string
}

variable "route53_zone_id" {
  type = string
}