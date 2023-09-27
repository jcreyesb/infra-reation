provider "aws" {
  version                 = "~> 4.55"
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "personal"
}

