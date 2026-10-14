# Proyecto 7 — Geoprocessing

> Estado: completado

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
- [x] **7.1** — Consultar y escribir en tus palabras qué hace cada una de estas herramientas: buffer, clip, dissolve, intersect, union, spatial join. Evidencia: [hallazgos](evidence/hallazgos.md)
- [x] **7.2** — Crear un buffer de 1 km alrededor de un punto de `puntos_manizales` (ej. Universidad de Caldas), trabajando en un CRS en metros (EPSG:6256). Evidencia: [hallazgos](evidence/hallazgos.md)
- [x] **7.3** — Intersectar ese buffer con la capa de comunas para identificar qué comunas quedan dentro, total o parcialmente. Evidencia: [hallazgos](evidence/hallazgos.md)

## Qué aprendí
- El geoprocesamiento crea capas nuevas a partir de relaciones espaciales, sin modificar las capas de entrada.
- La distancia de un buffer usa las unidades del CRS de la capa: hay que reproyectar a un CRS métrico antes de calcularlo.
- *Selected features only* limita una herramienta a las entidades seleccionadas.
- Intersect conserva los atributos de las dos capas, pero no recalcula los campos derivados de la geometría (igual que *Split*).
- Los datos oficiales pueden traer geometrías inválidas (autointersecciones) que bloquean el geoprocesamiento; *Fix geometries* las corrige.
- Validar el resultado contra un valor teórico (π·r²) confirma que la operación no perdió ni duplicó área, y obliga a explicar cada diferencia.

## Problemas encontrados y solución
**7.3 — La intersección falló por geometrías inválidas.** QGIS detuvo el proceso con *Feature (3) has invalid geometry*. Al revisar, dos comunas (Estación y Nuevo Horizonte) tenían autointersecciones en el borde. Solución: *Fix geometries* (Processing Toolbox → Vector geometry) sobre una copia de la capa, y repetir la intersección con la capa corregida.

**7.3 — No se encontraba *Fix geometries* en el menú.** En esta versión de QGIS no aparece en *Vector → Geometry Tools*. Solución: buscarla en la *Processing Toolbox* (*Processing → Toolbox*, escribir `fix`).

## Preguntas de entrevista
- **¿Cuál es la diferencia entre intersect y union?** Intersect devuelve solo las áreas donde ambas capas se superponen; union devuelve todas las áreas de ambas capas, se superpongan o no, combinando sus atributos.
- **¿Para qué sirve un spatial join?** Para transferir atributos de una capa a otra basándose en su relación espacial (ej. asignar el nombre del barrio a cada punto que cae dentro de él), sin necesidad de un campo en común.
- **¿Qué haces si una herramienta de geoprocesamiento falla por geometría inválida?** Identifico qué entidades son inválidas y por qué (en este caso, autointersecciones en dos comunas), las corrijo con *Fix geometries* sobre una copia, sin tocar el original, y repito la operación. Luego valido el resultado, por ejemplo comparando la suma de áreas con el valor esperado.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
- `hallazgos.md`: hallazgos de los 3 ejercicios, con sus capturas.
- `7.2-buffer.png`: buffer de 1 km alrededor de la Universidad de Caldas.
- `7.3-interseccion-mapa.png`, `7.3-interseccion-tabla.png`: intersección del buffer con las comunas y áreas resultantes.
