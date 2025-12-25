terraform {
  backend "s3" {
    bucket = "terraform-fuzzyfox"
    key = "backend"
    region = "us-east-1"
  }
}