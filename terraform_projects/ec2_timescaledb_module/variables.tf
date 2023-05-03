variable "instance_type" {
  description = "The instance type to use for the EC2 instance"
  default     = "t2.micro"
}

variable "key_name" {
  description = "The name of the SSH key pair to use for the EC2 instance"
}

variable "subnet_id" {
  description = "The ID of the subnet to launch the EC2 instance in"
}

variable "timescaledb_username" {
  description = "The username to use for TimescaleDB authentication"
}

variable "timescaledb_password" {
  description = "The password to use for TimescaleDB authentication"
}