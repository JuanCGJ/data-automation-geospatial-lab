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

## Ejercicios
1. Consultar y escribir en tus palabras qué son y para qué se usa cada uno de estos formatos: shapefile, GeoJSON, KML/KMZ, GeoPackage, CSV con coordenadas.
2. Descargar un dataset abierto de tu ciudad (ej. barrios o comunas) en formato shapefile.
3. En QGIS, convertir ese shapefile a GeoJSON y a GeoPackage (exportar capa como).
4. Crear o descargar un CSV con columnas de latitud y longitud, y cargarlo en QGIS como capa de puntos.
5. Tomar una captura de pantalla de cada formato cargado en QGIS.

## Progreso (checklist)

## Qué aprendí

## Problemas encontrados y solución

## Preguntas de entrevista
- **¿Cuándo usarías GeoPackage en vez de shapefile?** Cuando necesitas guardar varias capas en un solo archivo, evitar las limitaciones del shapefile (nombres de campo cortos, múltiples archivos asociados) o trabajar con un formato más moderno y abierto recomendado por OGC.
- **¿Qué diferencia hay entre GeoJSON y KML?** GeoJSON está pensado para intercambio de datos y aplicaciones web (estructura JSON estándar); KML está pensado para visualización en Google Earth, con soporte para estilos y elementos visuales que GeoJSON no maneja de forma nativa.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
