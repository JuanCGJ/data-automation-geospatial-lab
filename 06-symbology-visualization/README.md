# Proyecto 6 — Simbología y visualización

> Estado: pendiente

## Objetivo
Aprender a simbolizar y etiquetar capas en QGIS para comunicar información visualmente.

## Requisitos
QGIS; la capa `activos` del Proyecto 5 (campo categórico `tipo`) y la capa de comunas del Proyecto 4 (campo numérico `area_km2`).

## Entregable
Mapa exportado como imagen usando el diseñador de impresión (layout) de QGIS.

## Conceptos
**Símbolo único:** toda la capa se muestra con el mismo estilo, sin distinguir entidades entre sí.

**Categorizado:** cada valor único de un campo (ej. tipo de uso de suelo) se muestra con un color/símbolo distinto.

**Graduado:** un campo numérico se divide en rangos, y cada rango tiene un color/tamaño distinto (ej. mapa de densidad).

**Etiquetas (labels):** texto mostrado sobre el mapa con el valor de un campo (ej. nombre de cada barrio).

## Ejercicios
1. Consultar y escribir la diferencia entre simbología de símbolo único, categorizado y graduado.
2. Simbolizar la capa `activos` por categoría según el campo `tipo`.
3. Simbolizar la capa de comunas por valor graduado según `area_km2`, y agregar etiquetas con el nombre de cada comuna.
4. Usar el diseñador de impresión (layout) de QGIS para exportar el mapa como imagen.

## Progreso (checklist)
- [x] **6.1** — Consultar y escribir la diferencia entre simbología de símbolo único, categorizado y graduado. Evidencia: [hallazgos](evidence/hallazgos.md)
- [ ] **6.2** — Simbolizar la capa `activos` por categoría según el campo `tipo`. Evidencia: pendiente
- [ ] **6.3** — Simbolizar la capa de comunas por valor graduado según `area_km2`, y agregar etiquetas con el nombre de cada comuna. Evidencia: pendiente
- [ ] **6.4** — Usar el diseñador de impresión (layout) de QGIS para exportar el mapa como imagen. Evidencia: pendiente

## Qué aprendí

## Problemas encontrados y solución

## Preguntas de entrevista
- **¿Cuándo usarías simbología graduada en vez de categorizada?** Graduada cuando el campo es numérico continuo y quieres mostrar intensidad o magnitud (ej. densidad); categorizada cuando el campo es discreto/categórico (ej. tipo de uso de suelo).
- **¿Para qué sirve una consulta de definición (definition query)?** Para mostrar solo un subconjunto de entidades de una capa sin crear una capa nueva ni modificar los datos originales.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
