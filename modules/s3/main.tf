variable "project" { type = string }
variable "env"     { type = string }
variable "region"  { type = string }
variable "tags"    { type = map(string) }

locals {
  name = "${var.project}-s3-${var.env}-${var.region}"
}

resource "aws_s3_bucket" "raw"        { bucket = "${local.name}-raw"   tags = var.tags }
resource "aws_s3_bucket" "bronze"     { bucket = "${local.name}-bronze" tags = var.tags }
resource "aws_s3_bucket" "silver"     { bucket = "${local.name}-silver" tags = var.tags }
resource "aws_s3_bucket" "gold"       { bucket = "${local.name}-gold"   tags = var.tags }
resource "aws_s3_bucket" "quarantine" { bucket = "${local.name}-quar"   tags = var.tags }
resource "aws_s3_bucket" "athena_out" { bucket = "${local.name}-athena" tags = var.tags }

output "bronze_bucket"     { value = aws_s3_bucket.bronze.bucket }
output "silver_bucket"     { value = aws_s3_bucket.silver.bucket }
output "gold_bucket"       { value = aws_s3_bucket.gold.bucket }
output "quarantine_bucket" { value = aws_s3_bucket.quarantine.bucket }
output "athena_output"     { value = "s3://${aws_s3_bucket.athena_out.bucket}/output/" }
