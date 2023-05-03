variable "bucket_name" {
  default     = "cdpass-terraform-state-bucket"
  description = "Add bucket name "
}

variable "object_key" {
  default     = "basic_infra/dev/terraform.tfstate"
  description = "add object key for remote state file "
}

variable "region" {
  default     = "us-west-2"
  description = "specify the aws region"
}

variable "timescaledb_instance_name" {
  default     = "timescaledb-instance"
  description = "define the ec2 instance name "
}

variable "timescaledb_ami" {
  default     = "ami-0dbdc6a2a81d0c0b1"
  description = "TimeScaleDB AMI"
}

variable "ec2_instance_type" {
  default     = "t2.micro"
  description = "define the ec2 instance type based on requirments"
}

variable "key_name" {
  description = "define aws key pair for ssh "

}

variable "aws_eip" {
  default     = true
  description = "set the aws elestic ip to true "
}

variable "name_prefix" {
  type        = string
  description = "The prefix for the security group name"
  default     = "timescaledb-sg-"
}

variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "The ingress rules for the security group"
  default = [{
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }, {
    from_port   = 5432
    to_port     = 5432
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }]
}
