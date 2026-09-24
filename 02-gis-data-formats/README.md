# Proyecto 2 — Formatos de datos geográficos

> Estado: completado

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
- [x] **2.1** — Instalar QGIS. Evidencia: [captura de QGIS instalado](evidence/2.1-qgis-instalado.png)
- [x] **2.2** — Consultar y escribir en tus palabras qué son y para qué se usa cada uno de estos formatos: shapefile, GeoJSON, KML/KMZ, GeoPackage, CSV con coordenadas. Evidencia: [formatos en mis palabras](evidence/2.2-formatos.md)
- [x] **2.3** — Descargar un dataset abierto de tu ciudad (ej. barrios o comunas) en formato shapefile. Evidencia: [capa Comunas cargada desde el servicio ArcGIS REST](evidence/2.3-comunas-arcgis-rest.png); shapefile en `data/comunas_manizales.*`
- [x] **2.4** — En QGIS, convertir ese shapefile a GeoJSON y a GeoPackage (exportar capa como). Evidencia: [archivos exportados](evidence/2.4-archivos-exportados.png) — GeoJSON reproyectado a EPSG:4326; GeoPackage conserva el CRS de origen (EPSG:6256)
-- [x] **2.5** — Crear o descargar un CSV con columnas de latitud y longitud, y cargarlo en QGIS como capa de puntos. Evidencia: [puntos del CSV sobre las comunas](evidence/2.5-puntos-csv.png); CSV en `data/puntos_manizales.csv`
- [x] **2.6** — Tomar una captura de pantalla de cada formato cargado en QGIS. Evidencia: [shapefile](evidence/2.6-shapefile.png), [GeoJSON](evidence/2.6-geojson.png), [GeoPackage](evidence/2.6-geopackage.png)

## Qué aprendí
## Qué aprendí
- Un shapefile no es un archivo sino varios (`.shp`, `.shx`, `.dbf`, `.prj`, `.cpg`); sin el `.prj`, los datos pierden su CRS.
- La diferencia entre **definir** un CRS (declarar en qué sistema están las coordenadas, sin moverlas) y **reproyectar** (transformar las coordenadas a otro sistema).
- GeoJSON exige WGS 84 (EPSG:4326), mientras que GeoPackage puede conservar el CRS original en un solo archivo con varias capas.
- Cuando un portal de descarga falla, se puede consumir la capa directamente desde su servicio ArcGIS REST en QGIS.
- Un servicio que reporta `wkid 0` usa un CRS personalizado; hay que identificar su equivalente oficial (en Manizales, EPSG:6256) para poder transformarlo.
- Superponer capas de distintas fuentes (como el CSV en WGS 84 sobre las comunas) es la forma práctica de detectar errores de CRS.
- Cargar un CSV con coordenadas: X = longitud, Y = latitud.

## Problemas encontrados y solución
**2.3 — La descarga del portal falló.** El portal de datos abiertos de la Alcaldía de Manizales (ArcGIS Hub) pedía iniciar sesión en un sitio, y en el otro respondía "intentar más tarde" en todos los formatos. Solución: obtuve la URL del Feature Service con la API pública de ArcGIS (`/sharing/rest/content/items/<id>?f=json`), conecté QGIS al servidor como capa ArcGIS REST y exporté la capa Comunas a shapefile.

**2.3 / 2.5 — CRS personalizado sin definición.** El servicio reportaba `Spatial Reference: 0` y el shapefile exportado quedó sin `.prj`. Le asigné el CRS que QGIS tomó del servicio (`CartManizalesMAGNA`), pero al cargar el CSV en WGS 84 los puntos cayeron lejos de la ciudad: QGIS no podía transformar ese CRS porque le faltaba la definición matemática. Solución: identifiqué el CRS oficial del IGAC, **EPSG:6256 (MAGNA-SIRGAS / Manizales urban grid)**, cuyo origen coincide con las coordenadas del servicio. Lo asigné al shapefile con *Define Projection*, cambié el CRS del proyecto y regeneré el GeoJSON y el GeoPackage.

## Preguntas de entrevista
- **¿Cuándo usarías GeoPackage en vez de shapefile?** Cuando necesitas guardar varias capas en un solo archivo, evitar las limitaciones del shapefile (nombres de campo cortos, múltiples archivos asociados) o trabajar con un formato más moderno y abierto recomendado por OGC.
- **¿Qué diferencia hay entre GeoJSON y KML?** GeoJSON está pensado para intercambio de datos y aplicaciones web (estructura JSON estándar); KML está pensado para visualización en Google Earth, con soporte para estilos y elementos visuales que GeoJSON no maneja de forma nativa.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
- `2.1-qgis-instalado.png`: QGIS instalado y funcionando.
- `2.2-formatos.md`: explicación de cada formato en mis palabras.
- `2.3-comunas-arcgis-rest.png`: capa Comunas cargada desde el servicio ArcGIS REST de la Alcaldía.
- `2.4-archivos-exportados.png`: el dataset en shapefile, GeoJSON y GeoPackage en `data/`.
- `2.5-puntos-csv.png`: puntos del CSV ubicados correctamente sobre las comunas.
- `2.6-*.png`: cada formato cargado por separado en QGIS.
