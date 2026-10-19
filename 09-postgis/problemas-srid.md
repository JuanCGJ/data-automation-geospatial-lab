# Proyecto 9 — Problemas con el SRID 6256 (explicación detallada)

Los dos problemas del ejercicio 9.5 tienen la misma raíz: **EPSG:6256 no se puede describir en el formato que todavía usan varias herramientas internamente**.

## La base: un SRID es solo un número

En PostGIS, cada geometría guarda un número, el **SRID** (6256 en este proyecto). Ese número por sí solo no dice nada. Para saber qué significa, PostGIS lo busca en una tabla que funciona como **diccionario**: `spatial_ref_sys`. Allí cada SRID tiene su definición completa: elipsoide, origen, unidades y proyección.

Esa definición se escribe en un formato de texto llamado **WKT** (*Well-Known Text*), que tiene dos versiones:
- **WKT1**: la versión antigua, la que todavía usan muchas herramientas internamente.
- **WKT2**: la versión moderna, que puede describir proyecciones más nuevas o más especiales.

**EPSG:6256 (MAGNA-SIRGAS / Manizales urban grid)** usa el método **"Colombia Urban"**. Este método proyecta sobre un plano elevado a 2100 m, la altura de la ciudad, para que las distancias en el mapa coincidan con las medidas en el terreno. WKT1 no tiene forma de expresar ese método; **solo WKT2 puede**.

## Problema 1: QGIS decía "Layer has no CRS" en `activos`

**Qué pasó:**
1. Al instalarse, PostGIS llena `spatial_ref_sys` con miles de sistemas de coordenadas tomados de la librería PROJ, escritos en **WKT1**.
2. Como el 6256 no cabe en WKT1, **se quedó por fuera** del diccionario.
3. Los puntos sí tenían SRID 6256 (diagnóstico 1: `ST_SRID` → 6256).
4. QGIS leyó la capa y buscó el 6256 en `spatial_ref_sys` para saber cómo dibujarla. **No lo encontró** (diagnóstico 2: la consulta no devolvió filas). Entonces mostró "Layer has no CRS" y los puntos no se alinearon con las comunas.

En otras palabras: los datos estaban bien, pero **faltaba la entrada en el diccionario**.

**Solución:**
- Agregar el 6256 a mano con un `INSERT INTO spatial_ref_sys`, con dos definiciones:
  - **`srtext`**: la definición en **WKT2**, que sí describe el método "Colombia Urban".
  - **`proj4text`**: la definición en formato **PROJ** (`+proj=col_urban ... +h_0=2100`), que es la que usa PostGIS para hacer los cálculos.
- `ON CONFLICT DO NOTHING` permite ejecutar el script varias veces sin error.

**Verificación:** se convirtió la Universidad de Caldas de metros (6256) a grados (4326) con `ST_Transform`. El resultado fue `(-75.493, 5.056)`, que son exactamente las coordenadas del CSV del Proyecto 2. Si la definición estuviera mal, el punto habría quedado en otro lugar.

Evidencia: `evidence/9.5-diag-0` a `evidence/9.5-diag-5` y `evidence/9.5-activos-postgis-qgis.png`.

## Problema 2: DB Manager decía "SRID must be <= 998999"

**Qué pasó:**
1. Un GeoPackage también tiene su propio diccionario interno (`gpkg_spatial_ref_sys`).
2. Cuando se creó `comunas_validas.gpkg`, la librería que escribe el archivo, GDAL, intentó guardar la definición del 6256 en **WKT1**. Como no pudo, la guardó como **`undefined`** (vacía).
3. Al abrir ese GeoPackage, QGIS vio el número 6256, pero sin definición. Así que no lo trató como el EPSG:6256 oficial, sino como un **CRS personalizado**, y le asignó un número interno propio, muy alto.
4. Al exportar con DB Manager, QGIS le pasó a PostGIS ese número interno. PostGIS **solo acepta SRID hasta 998999**, así que rechazó la importación.
5. Asignar el CRS de la capa a mano no lo resolvió. Lo más probable es que el exportador siguiera tomando el CRS que venía del archivo, no el que se asignó.

**Solución:** no usar QGIS para el traspaso.
- Se generó el script `sql/comunas.sql` leyendo directamente el GeoPackage. Cada comuna se inserta así:
  ```sql
  ST_GeomFromText('MULTIPOLYGON(...)', 6256)
  ```
- La geometría va como texto (WKT de geometría, que es distinto al WKT de CRS) y **el SRID se escribe explícitamente**. Así no hay ninguna herramienta en medio "interpretando" el CRS.
- Como el 6256 ya estaba registrado gracias al problema 1, PostGIS lo aceptó sin problema.
- Ventaja extra: la carga es **reproducible**. Cualquiera que clone el repo puede ejecutar el script y obtener las mismas 12 comunas, sin pasos manuales en QGIS.

**Verificación:** las 12 comunas cargaron con geometrías válidas y un área total de unos 35.80 km². Además, `ST_Contains` confirmó que los 5 activos caen en su comuna.

Evidencia: `evidence/9.5-dbmanager-1-import.png`, `evidence/9.5-dbmanager-2-error.png`, `evidence/9.5-comunas-cargadas.png` y `evidence/9.5-verificacion-contains.png`.

## Para la entrevista

> "El SRID es solo un número; su significado vive en `spatial_ref_sys`. El CRS local de Manizales no venía registrado porque su método no cabe en WKT1, así que lo registré con su definición WKT2 y PROJ y lo validé reproyectando un punto conocido. Para cargar las comunas evité la conversión de QGIS y generé un script SQL con el SRID explícito, que además deja la carga reproducible."
