variable "bucket_name" {
  type        = string
  default     = "http://localhost:4566" #"cdpass-terraform-state-bucket"
  description = "Add bucket name "
}

variable "object_key" {
  type        = string
  default     = "http://localhost:4566" #"basic_infra/dev/terraform.tfstate"
  description = "add object key for remote state file "
}

variable "region" {
  type        = string
  default     = "us-west-2"
  description = "specify the aws region"
}

variable "private_subnet_cidr" {
  type        = list(any)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "private subnets cidr blocks"
}

variable "role_name" {
  type        = string
  default     = "lambda_execution_role"
  description = "IAM role name which is attached with lambda function"
}

variable "policy_name" {
  type        = string
  default     = "lambda_policy"
  description = "lambda execution policy name or name of IAM policy for lambda function "
}

variable "allowed_actions" {
  type        = list(string)
  default     = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
  description = "list of action that are allowed in IAM policy which is attched to lambda function"
}

variable "lambda_payload" {
  type        = string
  default     = "lambda_function_payload.zip"
  description = "the file name which contains the lambda execution script"
}

variable "lambda_runtime" {
  type        = string
  default     = "python3.8"
  description = "specify the runtime required for lambda function execution"
}

variable "event_rule" {
  type        = string
  default     = "cron(0 23,9 ? * MON-FRI *)"
  description = "define the event brigde trigger rule"
}

variable "name_prefix" {
  type        = string
  description = "The prefix to use for the security group name."
  default     = "lambda_sg_"
}

variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "The ingress rules for the security group."
  default = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}

variable "egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "The egress rules for the security group."
  default = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "udp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]
}
