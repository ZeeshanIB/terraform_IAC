data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = var.bucket_name
    key    = var.object_key
    region = var.region
  }
}

module "timescaledb_instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws" # not allowed to use variable here
  name                   = var.timescaledb_instance_name
  version                = "4.3.0" # not allowed to use variable here
  ami                    = var.timescaledb_ami
  instance_type          = var.ec2_instance_type
  subnet_id              = data.terraform_remote_state.vpc.outputs.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.timescaledb_sg.id]
  key_name               = var.key_name
  user_data              = <<-EOF
    #!/bin/bash
    
    # Install and configure TimeScaleDB
    ...
    
    # Create database user and grant permissions
    sudo -u postgres psql -c "CREATE USER myuser WITH PASSWORD 'mypassword';"
    sudo -u postgres psql -c "CREATE DATABASE mydb OWNER myuser;"
    sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE mydb TO myuser;"
    
    # Enable password authentication
    sudo sed -i 's/^host all all 127.0.0.1\/32 trust$/host all all 127.0.0.1\/32 md5/' /etc/postgresql/12/main/pg_hba.conf
    sudo service postgresql restart
  EOF

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "timescaledb_sg" {
  name_prefix = var.name_prefix
  description = "Security group for TimeScaleDB"

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}



resource "aws_eip" "timescaledb_eip" {
  vpc = var.aws_eip

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_eip_association" "timescaledb_eip_association" {
  instance_id   = module.timescaledb_instance.id
  allocation_id = aws_eip.timescaledb_eip.id

}
