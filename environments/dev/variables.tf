variable "aws_region" {
  type = string
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "name" {
  type    = string
  default = "platform"
}

variable "owner" {
  type    = string
  default = "platform-team"
}

variable "vpc_cidr" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "single_nat_gateway" {
  type    = bool
  default = true
}

variable "kubernetes_version" {
  type = string
}

variable "node_instance_types" {
  type = list(string)
}

variable "node_desired_size" {
  type = number
}

variable "node_min_size" {
  type = number
}

variable "node_max_size" {
  type = number
}
