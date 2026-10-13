# Proyecto 7 — Geoprocessing

> Estado: pendiente

## Objetivo
Aprender las herramientas de geoprocesamiento espacial más usadas en QGIS.

## Requisitos
QGIS; la capa `puntos_manizales` y la capa de comunas del Proyecto 2.

## Entregable
Capa resultado de la intersección + explicación escrita de qué hace cada herramienta.

## Conceptos
**Buffer:** genera una zona de influencia (polígono) alrededor de una entidad, a una distancia definida.

**Clip:** recorta una capa usando los límites de otra.

**Dissolve:** fusiona entidades adyacentes que comparten el valor de un atributo, eliminando las fronteras entre ellas.

**Intersect:** genera una nueva capa con las áreas donde dos capas se superponen.

**Union:** combina dos capas conservando todos los atributos de ambas, incluso donde no se superponen.

**Spatial join:** transfiere atributos de una capa a otra según su relación espacial (ej. "está dentro de", "está a menos de X metros").

## Ejercicios
1. Consultar y escribir en tus palabras qué hace cada una de estas herramientas: buffer, clip, dissolve, intersect, union, spatial join.
2. Crear un buffer de 1 km alrededor de un punto de `puntos_manizales` (ej. Universidad de Caldas), trabajando en un CRS en metros (EPSG:6256).
3. Intersectar ese buffer con la capa de comunas para identificar qué comunas quedan dentro, total o parcialmente.

## Progreso (checklist)
- [ ] **7.1** — Consultar y escribir en tus palabras qué hace cada una de estas herramientas: buffer, clip, dissolve, intersect, union, spatial join. Evidencia: pendiente
- [ ] **7.2** — Crear un buffer de 1 km alrededor de un punto de `puntos_manizales` (ej. Universidad de Caldas), trabajando en un CRS en metros (EPSG:6256). Evidencia: pendiente
- [ ] **7.3** — Intersectar ese buffer con la capa de comunas para identificar qué comunas quedan dentro, total o parcialmente. Evidencia: pendiente

## Qué aprendí

## Problemas encontrados y solución

## Preguntas de entrevista
- **¿Cuál es la diferencia entre intersect y union?** Intersect devuelve solo las áreas donde ambas capas se superponen; union devuelve todas las áreas de ambas capas, se superpongan o no, combinando sus atributos.
- **¿Para qué sirve un spatial join?** Para transferir atributos de una capa a otra basándose en su relación espacial (ej. asignar el nombre del barrio a cada punto que cae dentro de él), sin necesidad de un campo en común.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
