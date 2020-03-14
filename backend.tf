terraform {
  required_version = "= 0.12.20"
  backend "s3" {
    region  = "ap-northeast-1"
    encrypt = true

    bucket = "{ Your terraform backend bucket }"
    key    = "firelens-sample/terraform.tfstate"

    profile = "{ Your Profile }"
  }
}

variable "profile" {
  default = "{ Your Profile }"
}

provider "aws" {
  version = "= 2.46.0"
  region  = "ap-northeast-1"
  profile = var.profile
}