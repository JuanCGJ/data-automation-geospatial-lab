# Proyecto 5 — Edición de geometrías

> Estado: completado

## Objetivo
Practicar la edición de geometrías en QGIS: crear, mover, dividir y unir entidades.

## Requisitos
QGIS; una copia de la capa de comunas del Proyecto 4 (`04-layers-and-attributes/data/comunas_manizales.gpkg`) para editar sin alterar los datos originales.

## Entregable
Capa editada + capturas antes/después.

## Conceptos
**Modo edición:** el estado en QGIS que permite modificar geometrías y atributos de una capa; hay que activarlo explícitamente y guardar los cambios al terminar.

**Crear/mover/eliminar vértices:** las operaciones básicas para construir o ajustar la forma de una línea o polígono.

**Dividir entidades (split features):** herramienta para cortar un polígono o línea en dos o más partes.

**Unir entidades (merge):** herramienta para combinar dos o más entidades seleccionadas en una sola.

## Ejercicios
1. Consultar y escribir cómo funcionan las herramientas de crear, mover y eliminar puntos, y de editar vértices de líneas y polígonos en QGIS.
2. Activar el modo edición y crear una capa nueva de puntos desde cero (ej. "activos" ficticios de tu ciudad: postes, cámaras, etc.).
3. Usar la herramienta de dividir entidades (split features) para dividir un polígono existente en dos, con captura antes y después de la edición.

> Nota: los antiguos ejercicios "captura antes" y "captura después" se fusionaron en el 5.3, porque eran la evidencia de la división y no ejercicios propios.

## Progreso (checklist)
- [x] **5.1** — Consultar y escribir cómo funcionan las herramientas de crear, mover y eliminar puntos, y de editar vértices de líneas y polígonos en QGIS. Evidencia: [hallazgos](evidence/hallazgos.md)
- [x] **5.2** — Activar el modo edición y crear una capa nueva de puntos desde cero (ej. "activos" ficticios de tu ciudad: postes, cámaras, etc.). Evidencia: [hallazgos](evidence/hallazgos.md)
- [x] **5.3** — Usar la herramienta de dividir entidades (split features) para dividir un polígono existente en dos, con captura antes y después de la edición. Evidencia: [hallazgos](evidence/hallazgos.md)

## Qué aprendí
- QGIS protege las capas: hay que activar el modo edición para modificarlas, y los cambios solo se escriben en el archivo al guardar.
- Una capa puede crearse vacía (definiendo geometría, CRS, campos y tipos) y llenarse digitalizando entidades con el mouse.
- Escribir los valores de texto con un formato uniforme evita categorías duplicadas (`poste` vs `Poste`).
- La diferencia entre una entidad (un punto se mueve con *Move Feature*) y un vértice (parte de una línea o polígono, se edita con *Vertex Tool*).
- Un archivo de proyecto (`.qgz`) solo apunta a los datos; para editar sin alterar otro proyecto hay que trabajar sobre una copia del archivo de datos.
- *Split Features* puede generar más de dos partes si la línea cruza el polígono varias veces, y la entidad original conserva solo uno de los pedazos.
- *Split* copia los atributos sin recalcularlos: los campos derivados de la geometría (como el área) quedan desactualizados y hay que recalcularlos.
- La suma de las áreas de las partes debe ser igual al área original: es una forma rápida de validar una edición.

## Problemas encontrados y solución
**5.3 — No aparecía la herramienta Split Features.** En el menú *Edit* solo se veía *Cut*, que corta la entidad al portapapeles y la elimina de la capa. Solución: *Split Features* está en *Edit → Edit Geometry → Split Features* (también en la barra *Advanced Digitizing*).

**5.3 — Las partes divididas tenían el área de la comuna completa.** Las 3 partes de Tesorito mostraban `area_km2` = 7,89, porque *Split* copia los atributos sin recalcularlos. Solución: recalcular el campo con `$area / 1000000` (*Update All* en la tabla) y verificar que la suma de las partes sea igual al área original.

## Preguntas de entrevista
- **¿Qué es el "modo edición" en QGIS y por qué es importante guardar los cambios?** Es el estado que habilita modificar geometrías y atributos. Mientras está activo, los cambios quedan en memoria; si no se guardan explícitamente, se pierden. Protege los datos contra modificaciones accidentales.
- **¿Qué diferencia hay entre dividir (split) y unir (merge) entidades?** Son operaciones inversas: *split* corta una entidad en varias partes que copian los atributos de la original; *merge* combina varias entidades en una sola y obliga a decidir qué atributos se conservan.
- **¿Qué riesgo tiene editar geometrías en una capa con campos calculados?** Que esos campos queden desactualizados, porque no se recalculan solos. Al dividir una comuna, cada parte heredó el área total; si no se recalcula, cualquier suma o análisis posterior cuenta el área varias veces.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
- `hallazgos.md`: hallazgos de los 3 ejercicios, con sus capturas.
- `5.2-capa-activos.png`: capa de puntos creada desde cero, con su tabla de atributos.
- `5.3-antes.png`, `5.3-despues.png`: comuna Tesorito antes y después de dividirla.