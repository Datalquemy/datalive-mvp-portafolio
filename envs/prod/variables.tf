variable "project" { type = string  default = "dqalq" }
variable "env"     { type = string  description = "dev | qa | prod" }
variable "region"  { type = string  default = "us-east-1" }
variable "tags"    { type = map(string) default = {} }

# Dominio inicial (Oil) - se puede cambiar/expandir
variable "domain"  { type = string  default = "oil" }
