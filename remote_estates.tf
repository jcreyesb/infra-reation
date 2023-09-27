terraform {
  backend "s3" {
    bucket = "terraformpersonal"
    key    = "states/infra.tfstate"
    region = "us-east-1"
   
  # shared_credentials_file = "~/.aws/credentials"
  # profile                 = "personal"
  }
}
