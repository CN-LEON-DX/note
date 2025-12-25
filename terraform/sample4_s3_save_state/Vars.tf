variable "REGION" {
  default = "us-east-1"
}

variable "ZONE_1" {
  default = "us-east-1a"
}

variable "WEB_USER" {
  default = "ubuntu"
}

variable "AMI_ID" {
  type = map(any)
  default = {
    us-east-1 = "ami-0ecb62995f68bb549"
    us-east-2 = "ami-0f5fcdfbd140e4ab7"
  }
}
