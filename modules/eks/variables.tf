variable "name" {
  description = "EKS cluster name."
  type        = string
}

variable "kubernetes_version" {
  description = "Supported EKS Kubernetes version, reviewed during upgrades."
  type        = string
}

variable "vpc_id" {
  description = "VPC that contains EKS control plane ENIs and nodes."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs across at least two AZs."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "EKS requires at least two private subnets in different AZs."
  }
}

variable "node_instance_types" {
  description = "Instance type fallback order for the managed node group."
  type        = list(string)
}

variable "node_desired_size" {
  description = "Initial desired worker-node count. Autoscaler ownership must be explicit before changing this."
  type        = number
}

variable "node_min_size" {
  description = "Minimum worker-node count."
  type        = number
}

variable "node_max_size" {
  description = "Maximum worker-node count."
  type        = number
}

variable "tags" {
  description = "Additional tags applied to supported resources."
  type        = map(string)
  default     = {}
}
