terraform {
  required_version = ">= 1.7.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.100.0"
    }
  }

  # Configure an S3 backend through a non-committed backend.hcl file. The
  # example documents encryption, locking, and state isolation requirements.
  backend "s3" {}
}
