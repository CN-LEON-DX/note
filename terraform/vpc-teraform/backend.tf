terraform {
  backend "s3" {
    bucket = "fuzzyfox145"
    key    = "terraform/backend"
    region = "us-east-1"
  }
}