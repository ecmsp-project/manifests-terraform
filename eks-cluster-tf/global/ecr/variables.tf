variable "region" {
  type        = string
  description = "AWS region to provision infrastructure."
}

variable "bucket" {
  type        = string
  description = "S3 bucket for terraform state."
}

variable "profile" {
  type        = string
  description = "Profile to use to assume proper role."
}

variable "github_repositories" {
  type        = list(string)
  description = "List of Github repositories to handle"
}