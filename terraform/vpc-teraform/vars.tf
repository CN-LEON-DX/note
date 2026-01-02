variable "ZONE1" {
  default = "us-east-2a"
}

variable "ZONE2" {
  default = "us-east-2b"
}

variable "ZONE3" {
  default = "us-east-2c"
}

variable "region" {
  default = "us-east-2"
}

variable "WEB_USER" {
  default = "ubuntu"
}

variable "amiID" {
  type = map(any)
  default = {
    us-east-2 = "ami-036841078a4b68e14"
    us-east-1 = "ami-0e2c8caa4b6378d8c"
  }
}