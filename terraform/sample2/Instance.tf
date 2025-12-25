resource "aws_instance" "web" {
  ami                    = data.aws_ami.amiID.id
  instance_type          = "t3.micro"
  key_name               = "dev_key"
  vpc_security_group_ids = [aws_security_group.dev_sg.id]
  availability_zone      = "us-east-1a"

  tags = {
    Name    = "dev_wev"
    Project = "dev"
  }
}

resource "aws_ec2_instance_state" "web_state" {
  instance_id = aws_instance.web.id
  state       = "running"
}