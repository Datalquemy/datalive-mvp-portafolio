# Raíz: compone módulos mínimos para el MVP (AWS Optimized)

module "s3" {
  source  = "../../modules/s3"
  project = var.project
  env     = var.env
  region  = var.region
  tags    = var.tags
}

module "glue" {
  source        = "../../modules/glue"
  project       = var.project
  env           = var.env
  region        = var.region
  domain        = var.domain
  s3_bronze     = module.s3.bronze_bucket
  s3_silver     = module.s3.silver_bucket
  s3_gold       = module.s3.gold_bucket
  s3_quarantine = module.s3.quarantine_bucket
  tags          = var.tags
}

module "dq" {
  source        = "../../modules/dq"
  project       = var.project
  env           = var.env
  region        = var.region
  catalog_name  = module.glue.database_name
  quarantine_s3 = module.s3.quarantine_bucket
  tags          = var.tags
}

module "athena" {
  source    = "../../modules/athena"
  project   = var.project
  env       = var.env
  region    = var.region
  s3_output = module.s3.athena_output
  tags      = var.tags
}

# QuickSight se deja como referencia (requiere setup manual/identity)
module "quicksight" {
  source  = "../../modules/quicksight"
  project = var.project
  env     = var.env
  region  = var.region
  tags    = var.tags
}
