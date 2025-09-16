# DatAlive — MVP Portafolio (AWS Optimized, PROD)  
**Guía paso a paso (CLI + Terraform)**

> Objetivo: dejar listo el backend remoto de Terraform (S3 + DynamoDB), desplegar la base del lake (buckets, Glue DB, Athena WG) y validar con una prueba mínima.

---

## 0) Pre‐requisitos

- **AWS CLI** configurado.
- **Terraform** instalado.
- **Repositorio** clonado/local: `C:\datalive-mvp-portafolio`.

### Terraform (Windows) — instalación rápida
```powershell
# Verifica
terraform -v

# Si no está:
choco install terraform -y
```

### .gitignore recomendado (raíz del repo)
> No borra archivos; solo evita que se suban.
```
.terraform/
.terraform.lock.hcl
*.tfstate
*.tfstate.*
crash.log
*.tfplan
*.backup
*.tmp
```

---

## 1) Crear/usar perfil AWS para el portafolio

```powershell
aws configure --profile dalive-prod
# AWS Access Key ID: <TU_ACCESS_KEY_ID>
# AWS Secret Access Key: <TU_SECRET_ACCESS_KEY>
# Default region name: us-east-1
# Default output format: json
```

Verificación:
```powershell
aws sts get-caller-identity --profile dalive-prod
aws configure list --profile dalive-prod
```

Usar el perfil en la sesión actual:
```powershell
$env:AWS_PROFILE = "dalive-prod"
```

---

## 2) Backend remoto de Terraform (S3 + DynamoDB)

### 2.1 Crear bucket para tfstate
```powershell
aws s3api create-bucket `
  --bucket dalive-tfstate-prod-us-east-1 `
  --region us-east-1

# Verificar
aws s3 ls | findstr dalive-tfstate-prod-us-east-1
```

**Endurecimiento mínimo**
```powershell
# Bloquear acceso público
aws s3api put-public-access-block `
  --bucket dalive-tfstate-prod-us-east-1 `
  --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

# Versioning
aws s3api put-bucket-versioning `
  --bucket dalive-tfstate-prod-us-east-1 `
  --versioning-configuration Status=Enabled

# Cifrado por defecto (SSE-S3 AES-256)
aws s3api put-bucket-encryption `
  --bucket dalive-tfstate-prod-us-east-1 `
  --server-side-encryption-configuration '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'
```

Verificación rápida:
```powershell
aws s3api get-public-access-block --bucket dalive-tfstate-prod-us-east-1
aws s3api get-bucket-versioning   --bucket dalive-tfstate-prod-us-east-1
aws s3api get-bucket-encryption   --bucket dalive-tfstate-prod-us-east-1
```

### 2.2 Tabla DynamoDB (state locking)
```powershell
aws dynamodb create-table `
  --table-name dalive-tflock-prod-us-east-1 `
  --attribute-definitions AttributeName=LockID,AttributeType=S `
  --key-schema AttributeName=LockID,KeyType=HASH `
  --billing-mode PAY_PER_REQUEST `
  --region us-east-1

# Debe estar ACTIVE
aws dynamodb describe-table --table-name dalive-tflock-prod-us-east-1 --region us-east-1
```

### 2.3 Configurar backend en Terraform
`C:\datalive-mvp-portafolio\envs\prod\backend.tf`
```hcl
terraform {
  backend "s3" {
    bucket         = "dalive-tfstate-prod-us-east-1"
    key            = "state/datalive-mvp-portafolio-prod.tfstate"
    region         = "us-east-1"
    dynamodb_table = "dalive-tflock-prod-us-east-1"
    encrypt        = true
  }
}
```

---

## 3) Despliegue con Terraform (PROD)

En `C:\datalive-mvp-portafolio\envs\prod`:

```powershell
terraform init
terraform fmt
terraform validate

# Ver plan
terraform plan -var-file="prod.tfvars"

# Opción profesional (guardar plan)
terraform plan -var-file="prod.tfvars" -out="plan.prod.tfplan"
terraform apply "plan.prod.tfplan"
```

**Resultado esperado**  
- S3 buckets: `dalive-s3-prod-us-east-1-{raw,bronze,silver,gold,quarantine,athena}`  
- Glue DB: `dalive_prod_oil`  
- Athena WorkGroup: `dalive_prod_wg` (output → `s3://dalive-s3-prod-us-east-1-athena/output/`)

> Nota: si ves *BucketAlreadyExists*, ajusta ligeramente `project` en `prod.tfvars` (e.g., `dalivep`) y repite plan/apply.

---

## 4) Prueba mínima (quick win)

### 4.1 Subir CSV de prueba a RAW
```powershell
@"
well_id,date,operator,oil_bbl
W-001,2025-09-01,AlphaOil,120
W-001,2025-09-02,AlphaOil,135
W-002,2025-09-01,BetaOil,90
W-002,2025-09-02,BetaOil,110
"@ | Out-File -FilePath .\sample_oil.csv -Encoding utf8

aws s3 cp .\sample_oil.csv s3://dalive-s3-prod-us-east-1-raw/staging/sample_oil.csv
```

### 4.2 Athena (usar WorkGroup `dalive_prod_wg`)
En Query Editor:
```sql
USE dalive_prod_oil;

CREATE EXTERNAL TABLE IF NOT EXISTS oil_daily (
  well_id  string,
  date     date,
  operator string,
  oil_bbl  int
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
  'separatorChar' = ',',
  'quoteChar'     = '"'
)
STORED AS TEXTFILE
LOCATION 's3://dalive-s3-prod-us-east-1-raw/staging/'
TBLPROPERTIES ('skip.header.line.count'='1');

SELECT operator, SUM(oil_bbl) AS total_bbl
FROM oil_daily
GROUP BY operator
ORDER BY total_bbl DESC;
```

**Evidencias sugeridas (para el README/portafolio)**  
- Captura de los buckets en S3.  
- Captura de la query en Athena con resultados.  
- (Opcional) Vista de la tabla en Glue.

---

## 5) Cambios de código realizados (resumen)

- `envs/prod/backend.tf`: backend S3 + lock DynamoDB.
- `envs/prod/variables.tf`: variables multilínea + `tags` estándar (`Owner=DatAlquemy`, `Maintainer=EmmanuelPerez`, `Project=DatAlive`, `Env=prod`) y `domain="oil"`.
- `envs/prod/main.tf`: rutas de módulos corregidas (`../../modules/...`), wiring de `athena` → `module.s3.athena_output`.
- `modules/s3/main.tf`: recursos S3 en formato correcto + outputs (`athena_output` incluido).

---


