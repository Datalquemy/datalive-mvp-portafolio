# QuickSight requiere configuración manual previa (identidad/namespace).
# Este módulo es referencial para mantener invariante del stack.
variable "project" { type = string }
variable "env" { type = string }
variable "region" { type = string }
variable "tags" { type = map(string) }

output "qs_placeholder" { value = "${var.project}-${var.env}-qs" }
