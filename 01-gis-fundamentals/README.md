# Proyecto 1 — Fundamentos GIS (teoría)

> Estado: pendiente

## Objetivo
Entender los conceptos fundamentales de GIS (dato espacial, capas, atributos, coordenadas, CRS, geometría) antes de empezar a usar herramientas.

## Requisitos
Ninguno técnico; solo un documento o carpeta `docs/` para registrar el glosario y el diagrama.

## Entregable
README con el glosario propio de términos GIS + el diagrama capa–atributo–geometría–CRS.

## Conceptos
**Dato espacial vs no espacial:** un dato espacial tiene una ubicación en el mundo (coordenadas); uno no espacial es solo un atributo sin ubicación (ej. un nombre o un precio).

**Capa (layer):** un conjunto de entidades geográficas del mismo tipo (ej. todos los barrios de una ciudad) que se muestra y gestiona como una unidad en un software GIS.

**Atributo:** la información no geométrica asociada a una entidad (ej. nombre, población, área de un barrio), guardada en la tabla de atributos.

**Coordenadas:** los valores (x, y) o (lat, long) que ubican un punto en el espacio.

**CRS (Coordinate Reference System):** el sistema que define cómo esas coordenadas se relacionan con ubicaciones reales en la Tierra. **EPSG** es el código estándar que identifica cada CRS (ej. EPSG:4326). **WGS84** es el CRS geográfico más usado a nivel mundial (el que usa GPS).

**Geometría:** la forma que representa una entidad — **punto** (una ubicación), **línea** (una calle, un río) o **polígono** (un barrio, un lote). **Vector** representa el mundo con estas geometrías discretas; **raster** lo representa como una grilla continua de píxeles (ej. una imagen satelital).

## Ejercicios
1. En un documento, consultar y escribir en tus palabras qué son los siguientes términos: dato espacial vs no espacial, capa, atributo, coordenadas.
2. En el mismo documento, consultar y escribir qué son y para qué sirven: CRS, EPSG, WGS84.
3. Consultar y escribir la diferencia entre geometría de tipo punto, línea y polígono, y la diferencia entre datos vector y raster.
4. Escribir un glosario propio, en tus palabras, de todos los términos vistos (guardarlo en `docs/`).
5. Hacer un diagrama simple de cómo se relacionan capa–atributo–geometría–CRS.

## Progreso (checklist)

## Qué aprendí

## Problemas encontrados y solución

## Preguntas de entrevista
- **¿Qué es un CRS y por qué importa?** Es el sistema que define cómo las coordenadas de una capa se ubican en el mundo real. Importa porque si dos capas tienen CRS distintos, no van a alinearse correctamente en el mapa aunque los datos sean correctos — hay que reproyectarlas a un mismo CRS antes de compararlas o cruzarlas.
- **¿Cuál es la diferencia entre datos vector y raster?** Vector representa el mundo con geometrías discretas (puntos, líneas, polígonos) y es ideal para entidades bien definidas (calles, lotes, edificios). Raster representa el mundo como una grilla continua de celdas/píxeles, ideal para fenómenos continuos (elevación, temperatura, imágenes satelitales).

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
