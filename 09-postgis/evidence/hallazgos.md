# Proyecto 9 — Hallazgos

## 9.1 — geometry, geography y SRID

PostGIS agrega a PostgreSQL dos **tipos de dato** para guardar ubicaciones y formas. Se usan igual que `INTEGER` o `VARCHAR` al crear una columna.

| | `geometry` | `geography` |
|---|---|---|
| Superficie | Un **plano** (como una hoja de papel) | La **Tierra curva** (elipsoide) |
| Unidades | Las del CRS: metros en EPSG:6256, grados en EPSG:4326 | Siempre **metros**, con coordenadas en grados (WGS 84) |
| Cálculo de distancia | Pitágoras: rápido y simple | Geodésico, sobre la curvatura: más lento |
| Funciones disponibles | Todas (más de mil) | Un subconjunto |
| Cuándo usarlo | Áreas pequeñas (una ciudad) con una proyección local adecuada | Distancias largas (países, rutas aéreas) o datos de todo el mundo |

**Decisión para este curso:** `geometry` con **SRID 6256** (MAGNA-SIRGAS / Manizales urban grid). Es la proyección oficial de la ciudad, mide en metros y es la misma que se usó en QGIS desde el Proyecto 2. En una ciudad de unos 10 km, la curvatura de la Tierra no cambia los resultados.

### SRID
El **SRID** (*Spatial Reference System Identifier*) es el número que indica en qué sistema de referencia están las coordenadas de una geometría. En PostGIS coincide con el código **EPSG**: SRID 6256 = EPSG:6256, SRID 4326 = WGS 84.

- Cada geometría guarda su SRID. Sin él, `(1175734, 1051047)` serían solo dos números: no se sabría si son metros de Manizales, grados o pies.
- PostGIS **no deja comparar geometrías con SRID distintos**: hay que reproyectar primero con `ST_Transform`. Es la misma lección del Proyecto 2, donde los puntos del CSV cayeron lejos por un CRS mal definido.
- La tabla del sistema `spatial_ref_sys` contiene la definición de cada SRID que PostGIS conoce.

## 9.2 — Funciones espaciales

Todas empiezan por `ST_` (*spatial type*) y se usan dentro de un `SELECT` o un `WHERE` normal.

| Función | Qué hace | Devuelve | Equivalente en QGIS |
|---|---|---|---|
| `ST_MakePoint(x, y)` | Crea un punto a partir de dos coordenadas (x = este, y = norte). Se combina con `ST_SetSRID(..., 6256)` para indicar el sistema | Geometría | Digitalizar un punto (5.2) |
| `ST_Distance(a, b)` | Distancia mínima entre dos geometrías, en las unidades del CRS | Número | Herramienta *Measure Line* (7.2) |
| `ST_DWithin(a, b, d)` | ¿Están a una distancia menor o igual que `d`? Usa el índice espacial, así que es más rápida que comparar `ST_Distance(a, b) <= d` | Verdadero / falso | Seleccionar lo que cae dentro de un buffer |
| `ST_Contains(a, b)` | ¿La geometría `a` contiene completamente a `b`? (por ejemplo, ¿la comuna contiene al punto?) | Verdadero / falso | *Select by location* |
| `ST_Intersects(a, b)` | ¿Las geometrías se tocan o se cruzan en algún punto? | Verdadero / falso | Condición previa de *Intersection* (7.3) |
| `ST_Buffer(g, d)` | Crea un polígono a una distancia `d` alrededor de la geometría | Geometría | *Buffer* (7.2) |

### Conceptos clave
- **Funciones que responden vs. funciones que crean:** `ST_DWithin`, `ST_Contains` e `ST_Intersects` responden sí o no y sirven para filtrar en el `WHERE`. `ST_MakePoint` e `ST_Buffer` crean geometrías nuevas.
- **`ST_Contains` vs. `ST_Intersects`:** `ST_Contains(comuna, punto)` exige que el punto esté dentro; `ST_Intersects` acepta cualquier contacto, incluso un borde compartido.
- **El orden importa en `ST_Contains`:** el contenedor va primero. `ST_Contains(comuna, punto)` puede ser verdadero; `ST_Contains(punto, comuna)` nunca lo es.
- **Índice espacial (GiST):** igual que el índice por fecha del Proyecto 8, pero en dos dimensiones. Guarda el rectángulo que envuelve cada geometría y descarta rápido las que están lejos, antes de calcular con precisión.
