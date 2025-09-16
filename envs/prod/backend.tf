terraform {
  backend "s3" {
    bucket         = "dalive-tfstate-prod-us-east-1"
    key            = "state/datalive-mvp-portafolio-prod.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dalive-tflock-prod-us-east-1"
    encrypt        = true
  }
}
