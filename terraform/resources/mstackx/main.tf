provider "aws" {
  region = "${var.region}"
}


terraform {
  backend "s3" {
    bucket         = "mstackx-terraform-state-abhijith"
    region         = "us-east-1"
    key            = "vpc.terraform.tfstate"
    dynamodb_table = "infra-lock"
    encrypt        = true
  }
}
