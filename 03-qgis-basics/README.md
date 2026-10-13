# Proyecto 3 — QGIS desde cero

> Estado: completado

## Objetivo
Familiarizarte con la interfaz de QGIS y el concepto de proyecto, capas y CRS del proyecto.

## Requisitos
QGIS instalado; las 3 capas generadas en el Proyecto 2 (shapefile, GeoJSON, GeoPackage).

## Entregable
Captura de la interfaz de QGIS, tablas de atributos de las 3 capas y notas sobre qué pasó al cambiar el CRS del proyecto.

## Conceptos
**Interfaz de QGIS:** panel de capas (lista las capas cargadas), tabla de atributos (datos no espaciales de cada capa), barra de herramientas (accesos a las funciones más usadas).

**Proyecto (.qgz):** el archivo que guarda la configuración de trabajo (qué capas están cargadas, su simbología, el CRS del proyecto, la vista del mapa), no los datos en sí.

**CRS del proyecto:** el sistema de coordenadas en el que QGIS muestra todas las capas en pantalla, independientemente del CRS nativo de cada una — QGIS las reproyecta "al vuelo" para que se alineen visualmente.

## Ejercicios
1. Explorar la interfaz de QGIS: identificar el panel de capas, la tabla de atributos y la barra de herramientas.
2. Abrir la tabla de atributos de cada una de las 3 capas del Proyecto 2 (shapefile, GeoJSON, GeoPackage) y revisar sus columnas.
3. Cambiar el CRS del proyecto (Propiedades del proyecto → CRS) y anotar qué cambia visualmente en las capas.


## Progreso (checklist)
- [x] **3.1** — Explorar la interfaz de QGIS: identificar el panel de capas, la tabla de atributos y la barra de herramientas. Evidencia: [hallazgos](evidence/hallazgos.md)
- [x] **3.2** — Abrir la tabla de atributos de cada una de las 3 capas y revisar sus columnas. Evidencia: [hallazgos](evidence/hallazgos.md)
- [x] **3.3** — Cambiar el CRS del proyecto y anotar qué cambia visualmente en las capas. Evidencia: [hallazgos](evidence/hallazgos.md)


## Qué aprendí
- Las zonas de QGIS: barra de herramientas, Browser (buscar datos), Layers (capas cargadas, donde la de arriba tapa a las de abajo), lienzo del mapa y barra de estado (coordenadas, escala y CRS).
- Una capa puede estar encendida y no verse porque la vista está en otro lugar; *Zoom to Layer(s)* lo resuelve.
- La tabla de atributos muestra los datos de cada entidad: filas = entidades, columnas = campos.
- El límite de 10 caracteres del shapefile aplica a los nombres de campo, no a los valores, y se hereda en todo lo que se exporta a partir de él. Conviene exportar desde la fuente original.
- El GeoPackage agrega un identificador propio (`fid`), y un identificador interno (`OBJECTID`) no tiene por qué coincidir con un código real (`nro`).
- Cambiar el CRS del proyecto no modifica los datos, solo cómo se dibujan (reproyección al vuelo).
- Un CRS usado lejos de su zona de diseño deforma las formas; cerca del ecuador, WGS 84 casi no deforma.
- Cuando dos CRS usan datums distintos, hay que elegir una transformación de datum; importa en trabajos de precisión.

## Problemas encontrados y solución
3.1 — La capa no aparecía en el mapa. Estaba encendida pero la vista estaba en otro lugar. Solución: clic derecho → *Zoom to Layer(s)*.

## Preguntas de entrevista
- **¿Qué diferencia hay entre el CRS de un proyecto y el CRS de una capa en QGIS?** El CRS de la capa es el sistema en el que fue creado/guardado el dato original; el CRS del proyecto es el sistema en el que QGIS muestra todas las capas en pantalla, reproyectándolas al vuelo si no coinciden.
- **¿Para qué sirve la tabla de atributos?** Para ver y editar la información no geométrica asociada a cada entidad de una capa (nombres, categorías, valores numéricos), y para filtrar o seleccionar entidades según esos valores.
- **¿Por qué una capa se ve deformada al cambiar el CRS del proyecto?** Porque cada proyección conserva unas propiedades (área, forma, distancia) a costa de otras, y está pensada para una región. Usada lejos de su zona, como LAEA Europe aplicada a Manizales, deforma las formas aunque los datos no cambien.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
- `hallazgos.md`: hallazgos de los 3 ejercicios, con sus capturas.
- `3.1-interfaz-qgis.png`: interfaz de QGIS con la tabla de atributos abierta.
- `3.2-tabla-geojson.png`, `3.2-tabla-geopackage.png`: tablas de atributos.
- `3.3-crs-6256.png`, `3.3-crs-4326.png`, `3.3-crs-3035.png`: la misma capa con tres CRS del proyecto.
