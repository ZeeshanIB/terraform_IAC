terraform {
  backend "s3" {
    bucket = "statefile" #bucket_name
    key    = "dev/terraform.tf" #update required 
    region = "us-west-2"
  }
}