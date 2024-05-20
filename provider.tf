# Configure provider
  provider "aws" { 
    region = "ca-central-1" 
    access_key=var.AWS_ACCESS_KEY 
    secret_key=var.AWS_SECRET_KEY 
  } 
