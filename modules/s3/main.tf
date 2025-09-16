#############################
# variables
#############################
variable "project" { type = string }
variable "env"     { type = string }
variable "region"  { type = string }
variable "tags"    { type = map(string) }

#############################
# locals
#############################
locals {
  name = "${var.project}-s3-${var.env}-${var.region}"
}

#############################
# buckets
#############################

# RAW
resource "aws_s3_bucket" "raw" {
  bucket = "${local.name}-raw"
  tags   = var.tags
}

# BRONZE
resource "aws_s3_bucket" "bronze" {
  bucket = "${local.name}-bronze"
  tags   = var.tags
}

# SILVER
resource "aws_s3_bucket" "silver" {
  bucket = "${local.name}-silver"
  tags   = var.tags
}

# GOLD
resource "aws_s3_bucket" "gold" {
  bucket = "${local.name}-gold"
  tags   = var.tags
}

# QUARANTINE
resource "aws_s3_bucket" "quarantine" {
  bucket = "${local.name}-quarantine"
  tags   = var.tags
}

# ATHENA (outputs)
resource "aws_s3_bucket" "athena_out" {
  bucket = "${local.name}-athena"
  tags   = var.tags
}

#############################
# outputs
#############################
output "raw_bucket"        { value = aws_s3_bucket.raw.bucket }
output "bronze_bucket"     { value = aws_s3_bucket.bronze.bucket }
output "silver_bucket"     { value = aws_s3_bucket.silver.bucket }
output "gold_bucket"       { value = aws_s3_bucket.gold.bucket }
output "quarantine_bucket" { value = aws_s3_bucket.quarantine.bucket }
output "athena_bucket"     { value = aws_s3_bucket.athena_out.bucket }
output "athena_output" {
  value = "s3://${aws_s3_bucket.athena_out.bucket}/output/"
}

