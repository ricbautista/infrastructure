variable "region"     {
  description = "AWS region to use"
  default     = "ap-southeast-2"
}

variable "environment" {
  description = "Infrastructure Environment"
}

variable "aws_account_id" {
  description= "AccountID for AWS"
  default = {
    "ops" = "871253612619"
  }
}

# Allows restriction of public access to http services
variable "public_http_allowed_cidrs" {
  default = {
    "ops" = "0.0.0.0/0"
  }
}

variable "deployserver_instance_type" {
  default = {
    "ops" = "t2.micro"
  }
}

variable "ebs_optimized" {
  default = {
    "ops" = "false"
  }
}

variable "deployserver_root_disk_size" {
  default = {
    "ops" = "50"
  }
}


variable "ops_dns_domain" {
  default = {
    "ops" = "ops.training.linuxdojo.com"
  }
}
