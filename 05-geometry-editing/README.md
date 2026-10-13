# Proyecto 5 — Edición de geometrías

> Estado: pendiente

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
- [ ] **5.2** — Activar el modo edición y crear una capa nueva de puntos desde cero (ej. "activos" ficticios de tu ciudad: postes, cámaras, etc.). Evidencia: pendiente
- [ ] **5.3** — Usar la herramienta de dividir entidades (split features) para dividir un polígono existente en dos, con captura antes y después de la edición. Evidencia: pendiente

## Qué aprendí

## Problemas encontrados y solución

## Preguntas de entrevista
- **¿Qué es el "modo edición" en QGIS y por qué es importante guardar los cambios?** Es el estado que habilita modificar geometrías/atributos; si no se guardan los cambios explícitamente (o se sale sin guardar), se pierden al cerrar el proyecto.
- **¿Qué diferencia hay entre dividir (split) y unir (merge) entidades?** Dividir corta una entidad en varias partes independientes; unir combina varias entidades seleccionadas en una sola geometría.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
