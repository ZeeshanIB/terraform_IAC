data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.bucket_name
    key    = var.object_key
    region = var.region
  }
}

resource "aws_subnet" "private_subnet_1" {
  cidr_block        = var.private_subnet_cidr[0]
  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  availability_zone = data.terraform_remote_state.vpc.outputs.azs[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_subnet" "private_subnet_2" {
  cidr_block        = var.private_subnet_cidr[1]
  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  availability_zone = data.terraform_remote_state.vpc.outputs.azs[1]


  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_iam_role" "lambda_execution_role" {
  name = var.role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_iam_policy" "lambda_policy" {
  name = var.policy_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = var.allowed_actions
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}

resource "aws_lambda_function" "my_lambda_function" {
  filename      = var.lambda_payload
  function_name = "my_lambda_function"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "lambda_function_handler"
  runtime       = var.lambda_runtime
  vpc_config {
    subnet_ids         = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


resource "aws_cloudwatch_event_rule" "lambda_trigger_rule" {
  name                = "lambda_trigger_rule"
  description         = "Run Lambda at 11:00 PM and 9:00 AM UTC on weekdays"
  schedule_expression = var.event_rule

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_cloudwatch_event_target" "target_lambda" {
  rule = aws_cloudwatch_event_rule.lambda_trigger_rule.name
  arn  = aws_lambda_function.my_lambda_function.arn
}

resource "aws_security_group" "lambda_sg" {
  name_prefix = var.name_prefix
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
