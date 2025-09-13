variable "project" { type = string }
variable "env" { type = string }
variable "region" { type = string }
variable "catalog_name" { type = string }
variable "quarantine_s3" { type = string }
variable "tags" { type = map(string) }

# Placeholder para reglas DQ/Deequ - implementar según dataset
output "dq_enabled" { value = true }
