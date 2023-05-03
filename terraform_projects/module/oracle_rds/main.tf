# Define a data source to get the VPC ID from a remote state file in S3
data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    bucket = var.networking_state_bucket
    key    = var.networking_state_key
    region = var.networking_state_region
  }
}

# Define the subnet group for the RDS instance
resource "aws_db_subnet_group" "oracle_subnet_group" {
  name        = var.subnet_group_name
  description = "Subnet group for Oracle RDS instance"

  subnet_ids = data.terraform_remote_state.networking.outputs.private_subnets
}

# Define the security group for the RDS instance
resource "aws_security_group" "oracle_sg" {
  name_prefix = var.security_group_name
  vpc_id      = data.terraform_remote_state.networking.outputs.vpc_id

  dynamic "ingress" {
    for_each = var.security_group_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  tags = var.tags
}

# Define the Oracle RDS instance
resource "aws_db_instance" "oracle_rds" {
  allocated_storage    = var.storage_size
  engine               = "oracle-se2"
  engine_version       = var.engine_version
  instance_class       = var.instance_type
  name                 = var.db_name
  username             = var.username
  password             = var.password
  db_subnet_group_name = aws_db_subnet_group.oracle_subnet_group.name
  vpc_security_group_ids = [
    aws_security_group.oracle_sg.id
  ]

  tags = var.tags
}
