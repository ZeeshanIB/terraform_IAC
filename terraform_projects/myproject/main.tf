module "timescaledb_instance" {
  source = "../ec2_timescaledb_module"

  instance_type        = "t2.micro"
  key_name             = "my-keypair"
  subnet_id            = "subnet-12345"
  timescaledb_username = "myusername"
  timescaledb_password = "mypassword"
}

output "instance_public_ip" {
  value = module.timescaledb_instance.instance_public_ip
}
