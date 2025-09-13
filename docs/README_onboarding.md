# README_onboarding.md — DatAlive MVP Portafolio (AWS Optimized)

## Objetivo
Desplegar **solo PROD** en AWS con costos mínimos y mantener invariantes para crecimiento a Starter/Premium.

## Prerequisitos (cliente o cuenta propia)
1. **IAM**: usuario/role para CI/CD con permisos restringidos (S3, Glue, Athena, QS).
2. **Backend Terraform**: bucket y tabla DynamoDB para `state` y locks.
3. **Región**: `us-east-1` (cambiable vía `var.region`).
4. **Etiquetas**: aplicar esquema mínimo: `Project=DatAlive, Env, Owner`.

## Pasos rápidos
1. Rellenar `envs/prod/backend.tf` con `bucket` y `dynamodb_table` reales.
2. `cd envs/prod && terraform init`
3. `terraform plan -var-file=prod.tfvars`
4. `terraform apply -var-file=prod.tfvars`

## Pruebas mínimas (staging en PROD)
- Crear prefijo temporal `staging/` en **raw** para datasets de prueba.
- Ejecutar crawler Glue y verificar tablas en **Glue Catalog**.
- Consultar con **Athena** (workgroup creado) y generar salida en `athena_output`.
- Validar regla DQ placeholder y flujo a `/raw/quarantine` (simulación).

## Siguientes pasos (Starter)
- Habilitar `envs/dev` y `envs/qa` con datos sintéticos.
- Activar pipeline CI/CD (GitHub Actions incluido).

