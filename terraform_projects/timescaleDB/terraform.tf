terraform {
  backend "s3" {
    bucket = "cdpass-terraform-state-bucket" #bucket_name
    key    = "timescaledb" #update required 
    region = "us-west-2"
  }
}