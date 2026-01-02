resource "aws_instance" "web" {
  ami               = var.amiID[var.region]
  instance_type     = "t3.micro"
  key_name          = "dev_key"
  subnet_id         = aws_subnet.dev-pub-01.id
  vpc_security_group_ids = [aws_security_group.dev_web_sg.id]
  availability_zone = var.ZONE1

  tags = {
    Name="Dev-web"
    Project="Dev"
  }

  provisioner "file" {
    source="web.sh"
    destination="/tmp/web.sh"
  }

  connection {
    type = "ssh"
    user = var.WEB_USER
    private_key = file("dev_key")
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/web.sh",
      "sudo /tmp/web.sh"
    ]
  }
  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }
}

resource "aws_ec2_instance_state" "web-state" {
  instance_id = aws_instance.web.id
  state       = "running"
}

output "Web_public_ip" {
  value = aws_instance.web.public_ip
  description = "Public IP instance"
}

output "web_private_ip" {
  value = aws_instance.web.private_ip
  description = "Private IP instance"
}