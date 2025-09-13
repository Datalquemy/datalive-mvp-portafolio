terraform {
  backend "s3" {
    bucket         = "<REPLACE_ME_BACKEND_BUCKET>"
    key            = "state/datalive-aws-optimized-PORTAFOLIO-qa.tfstate"
    region         = "us-east-1"
    dynamodb_table = "<REPLACE_ME_DDB_LOCK>"
    encrypt        = true
  }
}
