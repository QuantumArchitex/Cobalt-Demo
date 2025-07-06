variable "tenant" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "target_id" {
  type = string
}

variable "ssl_cert_arn" {
  type = string
}