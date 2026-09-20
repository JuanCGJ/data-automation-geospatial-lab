# Proyecto 2 — Formatos de datos geográficos

> Estado: pendiente

## Objetivo
Conocer los formatos de datos geográficos más comunes y practicar la conversión entre ellos usando QGIS.

## Requisitos
QGIS instalado; acceso a un portal de datos abiertos de tu ciudad o país; conexión a internet.

## Entregable
El mismo dataset en shapefile, GeoJSON y GeoPackage, más capturas de cada conversión.

## Conceptos
**Shapefile:** formato clásico de Esri compuesto por varios archivos (.shp, .shx, .dbf, etc.) que deben mantenerse juntos; ampliamente soportado pero con limitaciones (nombres de campo de máx. 10 caracteres, sin soporte nativo para múltiples geometrías).

**GeoJSON:** formato de texto basado en JSON, liviano y fácil de usar en aplicaciones web; un solo archivo, legible por humanos.

**KML/KMZ:** formato de Google Earth, pensado para visualización más que para análisis (KMZ es la versión comprimida).

**GeoPackage (.gpkg):** contenedor único basado en SQLite que puede guardar múltiples capas vectoriales y raster en un solo archivo; formato abierto y moderno recomendado por OGC.

**CSV con coordenadas:** un archivo tabular normal que incluye columnas de latitud/longitud, lo que permite cargarlo como capa de puntos en un GIS.

**QGIS: LTR vs versión "latest":** QGIS tiene dos ramas de lanzamiento. La **LTR (Long Term Release)** es la versión con soporte extendido, más estable y probada — la recomendada para trabajo real. La versión **"latest"** trae las funciones más nuevas, pero con menos tiempo de prueba y más posibilidad de bugs. En este curso usamos LTR, priorizando estabilidad sobre features de punta.

## Ejercicios
1. Instalar QGIS.
2. Consultar y escribir en tus palabras qué son y para qué se usa cada uno de estos formatos: shapefile, GeoJSON, KML/KMZ, GeoPackage, CSV con coordenadas.
3. Descargar un dataset abierto de tu ciudad (ej. barrios o comunas) en formato shapefile.
4. En QGIS, convertir ese shapefile a GeoJSON y a GeoPackage (exportar capa como).
5. Crear o descargar un CSV con columnas de latitud y longitud, y cargarlo en QGIS como capa de puntos.
6. Tomar una captura de pantalla de cada formato cargado en QGIS.

## Progreso (checklist)
- [ ] **2.1** — Instalar QGIS. Evidencia: pendiente (captura de pantalla al finalizar la instalación)
- [ ] **2.2** — Consultar y escribir en tus palabras qué son y para qué se usa cada uno de estos formatos: shapefile, GeoJSON, KML/KMZ, GeoPackage, CSV con coordenadas. Evidencia: pendiente
- [ ] **2.3** — Descargar un dataset abierto de tu ciudad (ej. barrios o comunas) en formato shapefile. Evidencia: pendiente
- [ ] **2.4** — En QGIS, convertir ese shapefile a GeoJSON y a GeoPackage (exportar capa como). Evidencia: pendiente
- [ ] **2.5** — Crear o descargar un CSV con columnas de latitud y longitud, y cargarlo en QGIS como capa de puntos. Evidencia: pendiente
- [ ] **2.6** — Tomar una captura de pantalla de cada formato cargado en QGIS. Evidencia: pendiente

## Qué aprendí

## Problemas encontrados y solución

## Preguntas de entrevista
- **¿Cuándo usarías GeoPackage en vez de shapefile?** Cuando necesitas guardar varias capas en un solo archivo, evitar las limitaciones del shapefile (nombres de campo cortos, múltiples archivos asociados) o trabajar con un formato más moderno y abierto recomendado por OGC.
- **¿Qué diferencia hay entre GeoJSON y KML?** GeoJSON está pensado para intercambio de datos y aplicaciones web (estructura JSON estándar); KML está pensado para visualización en Google Earth, con soporte para estilos y elementos visuales que GeoJSON no maneja de forma nativa.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
