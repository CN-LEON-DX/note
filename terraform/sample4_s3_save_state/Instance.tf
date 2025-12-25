# check region -> then select the correct IAM id
resource "aws_instance" "web" {
  ami                    = var.AMI_ID[var.REGION]
  instance_type          = "t3.micro"
  key_name               = "dev_key"
  vpc_security_group_ids = [aws_security_group.dev_sg.id]
  availability_zone      = var.ZONE_1

  tags = {
    Name    = "dev_wev"
    Project = "dev"
  }
  provisioner "file" {
    source      = "web.sh"
    destination = "/tmp/web.sh"
  }
  connection {
    type        = "ssh"
    user        = var.WEB_USER
    private_key = file("dev-key")
    host        = self.public_ip
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

resource "aws_ec2_instance_state" "web_state" {
  instance_id = aws_instance.web.id
  state       = "running"
}
# Output
output "WebPublicIp" {
  description = "public ip instance"
  value       = aws_instance.web.public_ip
}

output "WebPrivateIp" {
  description = "private ip instance"
  value       = aws_instance.web.private_ip
}