# DatAlive — MVP Portafolio (AWS Optimized, PROD-only)

Este repositorio es el **esqueleto** del MVP de portafolio en **AWS (Optimized)** con foco en **PROD-only** y ruta clara a **Starter → Premium/Enterprise** sin reconstrucción.

> **Invariantes (anti-arrepentimiento):**
> - Naming/Tagging: `dqalq-<serv>-<env>-<region>-<sufijo>`
> - Layout S3: `/raw/ /bronze/ /silver/ /gold/` con partición por fecha/dominio
> - Catálogo único: **AWS Glue Data Catalog**
> - Calidad: **Glue Data Quality / Deequ** + `/raw/quarantine`
> - BI: **QuickSight** sobre **Athena (GOLD)**
> - IaC: `modules/` + `envs/{dev,qa,prod}` (solo se aplica `prod` en el portafolio)

## Estructura

```
modules/           # Módulos Terraform por dominio técnico
  s3/              # Buckets y políticas (raw/bronze/silver/gold/quarantine)
  glue/            # Catálogo, crawlers, bases de datos
  dq/              # Reglas Glue DQ/Deequ
  athena/          # Workgroup, named queries, outputs
  quicksight/      # Carpetas, datasets, permiso mínimo (referencia)
  iam/             # Roles para pipelines y servicios
envs/
  dev/ qa/ prod/   # tfvars + backends remotos (solo 'prod' se aplica hoy)
.github/workflows/ # CI/CD (plan/apply con approval)
docs/              # Onboarding, decisiones, evidencias
```

## Roadmap de crecimiento
- Portafolio (hoy): `prod` solamente, pruebas vía *staging* efímero dentro de PROD.
- Starter (mañana): habilitar `dev` y `qa` con los **mismos módulos** (datos sintéticos).
- Premium/Enterprise: opcional **Databricks** (DLT/Unity/Expectations), ML, RAG, DR/Compliance.

