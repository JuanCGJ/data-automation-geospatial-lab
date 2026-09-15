# Proyecto 3 — QGIS desde cero

> Estado: pendiente

## Objetivo
Familiarizarte con la interfaz de QGIS y el concepto de proyecto, capas y CRS del proyecto.

## Requisitos
QGIS instalado; las 3 capas generadas en el Proyecto 2 (shapefile, GeoJSON, GeoPackage).

## Entregable
Captura del proyecto con las 3 capas cargadas + notas sobre qué pasó al cambiar el CRS.

## Conceptos
**Interfaz de QGIS:** panel de capas (lista las capas cargadas), tabla de atributos (datos no espaciales de cada capa), barra de herramientas (accesos a las funciones más usadas).

**Proyecto (.qgz):** el archivo que guarda la configuración de trabajo (qué capas están cargadas, su simbología, el CRS del proyecto, la vista del mapa), no los datos en sí.

**CRS del proyecto:** el sistema de coordenadas en el que QGIS muestra todas las capas en pantalla, independientemente del CRS nativo de cada una — QGIS las reproyecta "al vuelo" para que se alineen visualmente.

## Ejercicios
1. Explorar la interfaz de QGIS: identificar el panel de capas, la tabla de atributos y la barra de herramientas.
2. Crear un nuevo proyecto en QGIS y cargar las 3 capas del Proyecto 2 (shapefile, GeoJSON, GeoPackage).
3. Abrir la tabla de atributos de cada capa y revisar sus columnas.
4. Cambiar el CRS del proyecto (Propiedades del proyecto → CRS) y anotar qué cambia visualmente en las capas.

## Progreso (checklist)
- [ ] **3.1** — Explorar la interfaz de QGIS: identificar el panel de capas, la tabla de atributos y la barra de herramientas. Evidencia: pendiente
- [ ] **3.2** — Crear un nuevo proyecto en QGIS y cargar las 3 capas del Proyecto 2 (shapefile, GeoJSON, GeoPackage). Evidencia: pendiente
- [ ] **3.3** — Abrir la tabla de atributos de cada capa y revisar sus columnas. Evidencia: pendiente
- [ ] **3.4** — Cambiar el CRS del proyecto (Propiedades del proyecto → CRS) y anotar qué cambia visualmente en las capas. Evidencia: pendiente

## Qué aprendí

## Problemas encontrados y solución

## Preguntas de entrevista
- **¿Qué diferencia hay entre el CRS de un proyecto y el CRS de una capa en QGIS?** El CRS de la capa es el sistema en el que fue creado/guardado el dato original; el CRS del proyecto es el sistema en el que QGIS muestra todas las capas en pantalla, reproyectándolas al vuelo si no coinciden.
- **¿Para qué sirve la tabla de atributos?** Para ver y editar la información no geométrica asociada a cada entidad de una capa (nombres, categorías, valores numéricos), y para filtrar o seleccionar entidades según esos valores.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
