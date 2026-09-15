variable "name" {
  description = "Short, stable name used in resource tags."
  type        = string
}

variable "vpc_cidr" {
  description = "RFC1918 CIDR allocated to the VPC."
  type        = string
}

variable "availability_zones" {
  description = "At least two explicitly selected availability zones."
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) >= 2 && length(distinct(var.availability_zones)) == length(var.availability_zones)
    error_message = "Use at least two unique availability zones for failure-domain resilience."
  }
}

variable "private_subnet_cidrs" {
  description = "One private subnet CIDR per availability zone."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_cidrs) == length(var.availability_zones)
    error_message = "private_subnet_cidrs must match availability_zones in length."
  }
}

variable "public_subnet_cidrs" {
  description = "One public subnet CIDR per availability zone for load balancers/NAT."
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) == length(var.availability_zones)
    error_message = "public_subnet_cidrs must match availability_zones in length."
  }
}

variable "single_nat_gateway" {
  description = "Use one NAT gateway only for low-cost non-production environments."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags applied to all supported resources."
  type        = map(string)
  default     = {}
}
