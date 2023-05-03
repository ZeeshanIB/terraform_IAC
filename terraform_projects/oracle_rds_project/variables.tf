variable "subnet_group_name" {
  type        = string
  description = "The name of the subnet group for the RDS instance."
}

variable "storage_size" {
  type        = number
  description = "The amount of storage (in gigabytes) to allocate for the RDS instance."
}

variable "engine_version" {
  type        = string
  description = "The version of the Oracle engine to use for the RDS instance."
}

variable "instance_type" {
  type        = string
  description = "The instance type to use for the RDS instance."
}

variable "db_name" {
  type        = string
  description = "The name of the database to create on the RDS instance."
}

variable "username" {
  type        = string
  description = "The username to use for connecting to the database."
}

variable "password" {
  type        = string
  description = "The password to use for connecting to the database."
}

variable "security_group_name" {
  type        = string
  description = "The prefix to use for the name of the security group."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to the resources created by this module."
}

variable "security_group_ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "A list of ingress rules to apply to the security group."
}

variable "networking_state_bucket" {
  type        = string
  description = "The name of the S3 bucket where the networking state file is stored."
  default     = "my-bucket"
}

variable "networking_state_key" {
  type        = string
  description = "The key of the networking state file in the S3 bucket."
  default     = "networking/terraform.tfstate"
}

variable "networking_state_region" {
  type        = string
  description = "The AWS region where the networking state file is stored."
  default     = "us-east-1"
}
