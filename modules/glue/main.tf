variable "project" { type = string }
variable "env"     { type = string }
variable "region"  { type = string }
variable "domain"  { type = string }
variable "s3_bronze" { type = string }
variable "s3_silver" { type = string }
variable "s3_gold"   { type = string }
variable "s3_quarantine" { type = string }
variable "tags"    { type = map(string) }

resource "aws_glue_catalog_database" "db" {
  name = "${var.project}_${var.env}_${var.domain}"
}

output "database_name" { value = aws_glue_catalog_database.db.name }
