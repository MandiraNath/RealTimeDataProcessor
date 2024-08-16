terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.53.0"
    }
  }
}
provider "aws" {
  region     = "us-east-1"
  access_key = "AKIA5TBEOJW4B7S7EM2K"
  secret_key = "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"
}
