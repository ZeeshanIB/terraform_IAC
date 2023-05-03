resource "aws_instance" "ec2" {
  ami           = "ami-0dbdc6a2a81d0c0b1" # TimescaleDB AMI ID
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.subnet_id

  user_data = <<-EOF
              #!/bin/bash
              echo "timescaledb_timescaledb_password=${var.timescaledb_password}" >> /etc/environment
              echo "timescaledb_timescaledb_username=${var.timescaledb_username}" >> /etc/environment
              EOF
}

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.ec2.public_ip
}