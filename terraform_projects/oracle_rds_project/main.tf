module "oracle_rds" {
  source = "/home/zeeshan/terraform/terraform_projects/module/oracle_rds"

  subnet_group_name            = var.subnet_group_name
  storage_size                 = var.storage_size
  engine_version               = var.engine_version
  instance_type                = var.instance_type
  db_name                      = var.db_name
  username                     = var.username
  password                     = var.password
  security_group_name          = var.security_group_name
  tags                         = var.tags
  security_group_ingress_rules = var.security_group_ingress_rules

  networking_state_bucket = var.networking_state_bucket
  networking_state_key    = var.networking_state_key
  networking_state_region = var.networking_state_region
}
