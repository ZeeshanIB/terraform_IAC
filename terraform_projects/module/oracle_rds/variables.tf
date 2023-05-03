variable "subnet_group_name" {
  description = "The name of the subnet group for the RDS instance"
  type        = string
}

variable "storage_size" {
  description = "The amount of storage to allocate for the RDS instance, in GB"
  type        = number
}

variable "engine_version" {
  description = "The version of the Oracle database engine to use"
  type        = string
}

variable "instance_type" {
  description = "The instance type to use for the RDS instance"
  type        = string
}

variable "db_name" {
  description = "The name of the database to create on the RDS instance"
  type        = string
}

variable "username" {
  description = "The username to use for the master user of the RDS instance"
  type        = string
}

variable "password" {
  description = "The password to use for the master user of the RDS instance"
  type        = string
}

variable "security_group_name" {
  description = "The prefix to use for the name of the security group for the RDS instance"
  type        = string
}

variable "tags" {
  description = "A map of tags to apply to the RDS instance and related resources"
  type        = map(string)
}

variable "security_group_ingress_rules" {
  description = "A list of ingress rules to apply to the security group for the RDS instance"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "networking_state_bucket" {
  type        = string
  description = "s3 bucket name where state file is located which contains the networking details"

}

variable "networking_state_key" {
  type        = string
  description = "s3 object key of state file which contains the networking details"

}

variable "networking_state_region" {
  type        = string
  description = "define aws region where the file is located"

}