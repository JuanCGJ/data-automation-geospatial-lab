# Data Automation & Geospatial Systems

Curso propio de preparación técnica en **sistemas GIS, automatización de workflows y bases de datos geoespaciales**, documentado paso a paso con ejercicios prácticos de automatización (n8n), georreferenciación/GIS y datos.

Cada carpeta es un proyecto independiente con teoría, ejercicios, entregable y preguntas de aprendizaje con su respuesta.

## Stack tecnológico (100% gratuito)

| Herramienta | Para qué |
|---|---|
| [QGIS](https://qgis.org/) | Sistema GIS de escritorio |
| [n8n](https://n8n.io/) (self-hosted, Docker) | Automatización de workflows |
| [PostgreSQL](https://www.postgresql.org/) + [PostGIS](https://postgis.net/) (Docker) | Base de datos y análisis espacial |
| Python (geopandas, shapely, psycopg) | Procesamiento geoespacial con código |
| Docker Desktop | Entorno reproducible, instalación mínima en la máquina local |
| Git + GitHub | Versionado y documentación |

## Estructura del repositorio

| Carpeta | Proyecto |
|---|---|
| `00-dev-environment` | Entorno de desarrollo |
| `01-gis-fundamentals` | Fundamentos GIS (teoría) |
| `02-gis-data-formats` | Formatos de datos geográficos |
| `03-qgis-basics` | QGIS desde cero |
| `04-layers-and-attributes` | Capas y atributos |
| `05-geometry-editing` | Edición de geometrías |
| `06-symbology-visualization` | Simbología y visualización |
| `07-geoprocessing` | Geoprocessing |
| `08-postgresql-fundamentals` | PostgreSQL desde cero |
| `09-postgis` | PostGIS |
| `10-n8n-fundamentals` | n8n desde cero |
| `11-n8n-postgresql` | n8n + PostgreSQL |
| `12-n8n-postgis-geofencing` | n8n + PostGIS (Geofencing) |
| `13-python-geospatial` | Python + datos geoespaciales |
| `14-capstone-geospatial-monitoring` | Capstone: Geospatial Asset Monitoring & Automation Platform |
| `docs/` | Preguntas de aprendizaje recopiladas por proyecto y guía rápida de git |

Cada proyecto sigue la misma plantilla: **Objetivo, Requisitos, Entregable, Conceptos, Ejercicios, Progreso, Aprendizajes, Problemas encontrados y solución, Preguntas de aprendizaje, Evidencia**.

## Cómo correr el entorno

Instrucciones detalladas de instalación (Docker Desktop, `docker-compose.yml` para PostgreSQL/PostGIS y n8n, QGIS) en `00-dev-environment/README.md`.

Inicio rápido:
```bash
cp .env.example .env      # en PowerShell: Copy-Item .env.example .env
# edita .env y reemplaza xxx por una contraseña propia
docker compose up -d
```
Las credenciales viven en `.env`, que está en `.gitignore` y nunca se sube al repositorio. Los puertos (PostgreSQL 5432, n8n 5678) solo escuchan en `127.0.0.1`.

## Progreso

Actualmente en **Proyecto 0 — Entorno de desarrollo**. Este README y el estado de cada carpeta se van actualizando a medida que se completa cada proyecto.
