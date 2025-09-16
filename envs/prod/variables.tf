variable "project" {
  type    = string
  default = "dqalq"
}

variable "env" {
  type    = string
  default = "prod"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "tags" {
  type = map(string)
  default = {
    Owner       = "Emmanuel"
    Environment = "prod"
    Project     = "datalive-mvp-portafolio"
  }
}
variable "domain" {
  type    = string
  default = "oil"
}
