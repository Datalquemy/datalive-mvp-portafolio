variable "project" { type = string }
variable "env" { type = string }
variable "region" { type = string }
variable "s3_output" { type = string }
variable "tags" { type = map(string) }

resource "aws_athena_workgroup" "this" {
  name = "${var.project}_${var.env}_wg"
  configuration {
    result_configuration { output_location = var.s3_output }
  }
  tags = var.tags
}

output "workgroup" { value = aws_athena_workgroup.this.name }
