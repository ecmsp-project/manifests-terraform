terraform {
  backend "s3" {
    region       = ""
    bucket       = ""
    key          = "dev/ec2/terraform.tfstate"
    use_lockfile = true
    encrypt      = true
    profile      = "terraform-admin"
  }
}
