# Proyecto 4 — Capas y atributos

> Estado: pendiente

## Objetivo
Aprender a trabajar con la tabla de atributos: tipos de dato, campos calculados y filtros.

## Requisitos
QGIS; la capa de comunas de Manizales del Proyecto 2 (`02-gis-data-formats/data/comunas_manizales.gpkg`).

## Entregable
Capa exportada con el nuevo campo calculado.

## Conceptos
**Tabla de atributos:** la tabla asociada a una capa donde cada fila es una entidad y cada columna un atributo.

**Tipos de dato:** entero, decimal, texto, fecha, booleano — cada campo de la tabla tiene un tipo que determina qué operaciones se le pueden aplicar.

**Calculadora de campos:** herramienta de QGIS para crear campos nuevos a partir de expresiones (ej. combinar o hacer operaciones con otros campos existentes).

**Selección y filtro:** seleccionar resalta entidades sin ocultar el resto; filtrar (consulta de definición) oculta las que no cumplen la condición, mostrando solo el subconjunto.

## Ejercicios
1. Revisar el tipo de dato de cada campo de la capa de comunas (Propiedades de la capa → Campos) y escribir qué tipos existen en QGIS (entero, decimal, texto, fecha, etc.).
2. Con la calculadora de campos, crear el campo `area_km2` (área de cada comuna en km²) y compararlo con el campo `Shape__Are`.
3. Usar la selección por expresión para seleccionar las comunas con `area_km2` mayor a un valor dado.
4. Exportar la selección filtrada como una nueva capa.

## Progreso (checklist)
- [ ] **4.1** — Revisar el tipo de dato de cada campo de la capa de comunas (Propiedades de la capa → Campos) y escribir qué tipos existen en QGIS (entero, decimal, texto, fecha, etc.). Evidencia: pendiente
- [ ] **4.2** — Con la calculadora de campos, crear el campo `area_km2` (área de cada comuna en km²) y compararlo con el campo `Shape__Are`. Evidencia: pendiente
- [ ] **4.3** — Usar la selección por expresión para seleccionar las comunas con `area_km2` mayor a un valor dado. Evidencia: pendiente
- [ ] **4.4** — Exportar la selección filtrada como una nueva capa. Evidencia: pendiente

## Qué aprendí

## Problemas encontrados y solución

## Preguntas de entrevista
- **¿Qué es un campo calculado y para qué sirve?** Es un campo nuevo generado a partir de una expresión sobre otros campos existentes (ej. densidad = población/área), útil para no tener que calcular manualmente valores derivados.
- **¿Cuál es la diferencia entre seleccionar y filtrar en QGIS?** Seleccionar resalta entidades que cumplen una condición sin ocultar las demás; filtrar (consulta de definición) oculta del todo las entidades que no cumplen la condición.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
