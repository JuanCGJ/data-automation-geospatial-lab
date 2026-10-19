# Proyecto 9 — PostGIS

> Estado: completado

## Objetivo
Aprender a extender PostgreSQL con PostGIS para guardar y consultar datos espaciales.

## Requisitos
Contenedor de PostgreSQL+PostGIS corriendo; tabla `monitoreo.activos` del Proyecto 8; capa de comunas corregida del Proyecto 7 (`07-geoprocessing/data/comunas_validas.gpkg`).

## Entregable
Script `.sql` con las consultas espaciales y sus resultados.

## Conceptos
**Geometry vs geography:** `geometry` trabaja en un plano cartesiano (más rápido, requiere elegir una proyección adecuada); `geography` trabaja sobre la esfera terrestre (cálculos de distancia más precisos a nivel global, pero más costosos).

**SRID:** el identificador numérico del sistema de referencia espacial usado por una columna geometry/geography (equivalente al código EPSG).

**Índices espaciales (GiST):** estructuras que aceleran las consultas espaciales (ej. "qué está cerca de X"), igual que un índice normal acelera un `WHERE`.

**Funciones espaciales:** `ST_MakePoint` (crea un punto), `ST_Distance` (calcula distancia entre geometrías), `ST_DWithin` (¿está dentro de X distancia?), `ST_Contains` (¿una geometría contiene a otra?), `ST_Intersects` (¿se cruzan dos geometrías?), `ST_Buffer` (genera una zona de influencia).

## Ejercicios
1. Consultar y escribir la diferencia entre los tipos de dato geometry y geography, y qué es un SRID.
2. Consultar y escribir qué hace cada una de estas funciones: `ST_MakePoint`, `ST_Distance`, `ST_DWithin`, `ST_Contains`, `ST_Intersects`, `ST_Buffer`.
3. Agregar una columna `geometry` (SRID 6256) a `monitoreo.activos` y asignar la ubicación de cada activo usando `ST_MakePoint`.
4. Escribir una consulta que devuelva la distancia de cada activo a la Universidad de Caldas (`ST_Distance`) y cuáles están a menos de 1 km (`ST_DWithin`), igual que el buffer de la 7.2.
5. Cargar la capa de comunas (corregida en la 7.3) a PostGIS desde QGIS (DB Manager) y verificarla con una consulta SQL que use `ST_Contains`; se usará como zonas en el Proyecto 12.

## Progreso (checklist)
- [x] **9.1** — Consultar y escribir la diferencia entre los tipos de dato geometry y geography, y qué es un SRID. Evidencia: [hallazgos](evidence/hallazgos.md)
- [x] **9.2** — Consultar y escribir qué hace cada una de estas funciones: `ST_MakePoint`, `ST_Distance`, `ST_DWithin`, `ST_Contains`, `ST_Intersects`, `ST_Buffer`. Evidencia: [hallazgos](evidence/hallazgos.md)
- [x] **9.3** — Agregar una columna `geometry` (SRID 6256) a `monitoreo.activos` y asignar la ubicación de cada activo usando `ST_MakePoint`. Evidencia: [hallazgos](evidence/hallazgos.md)
- [x] **9.4** — Escribir una consulta que devuelva la distancia de cada activo a la Universidad de Caldas (`ST_Distance`) y cuáles están a menos de 1 km (`ST_DWithin`). Evidencia: [hallazgos](evidence/hallazgos.md)
- [x] **9.5** — Cargar la capa de comunas (corregida en la 7.3) a PostGIS y verificarla con una consulta SQL que use `ST_Contains`. Evidencia: [hallazgos](evidence/hallazgos.md)

## Qué aprendí
- PostGIS es una extensión de PostgreSQL: el mismo SQL, con nuevos tipos (`geometry`, `geography`) y funciones `ST_`.
- `geometry` con una proyección local en metros (SRID 6256) es lo adecuado para una ciudad; `geography` conviene para distancias largas.
- Una columna `geometry(Point, 6256)` restringe tipo y SRID; un índice GiST acelera las consultas espaciales.
- `ST_MakePoint` + `ST_SetSRID` crean puntos; `UPDATE` sin `WHERE` modificaría todas las filas.
- `ST_Distance` y `ST_DWithin` reproducen el análisis del buffer de la 7.2 sin crear geometrías.
- Un JOIN espacial (`ST_Contains`) relaciona tablas por ubicación, no por un campo común.
- PostGIS depende de `spatial_ref_sys` para entender un SRID; un CRS que falta ahí rompe la interoperabilidad con QGIS.
- Cuando una herramienta gráfica falla, un script SQL es una alternativa reproducible.
- QGIS y PostGIS comparten los mismos motores (GEOS y PROJ), por eso sus resultados coinciden.

## Problemas encontrados y solución
**9.5 — QGIS mostraba `activos` sin CRS.** PostGIS no traía EPSG:6256 en `spatial_ref_sys` (el método *Colombia Urban* no cabe en WKT1). Solución: registrarlo con `INSERT INTO spatial_ref_sys` (definición WKT2 y PROJ) y verificarlo con `ST_Transform`.

**9.5 — DB Manager fallaba con `SRID must be <= 998999`.** El GeoPackage guarda EPSG:6256 sin definición y QGIS lo trató como un CRS personalizado. Solución: cargar las comunas con un script SQL (`sql/comunas.sql`) usando `ST_GeomFromText(..., 6256)`.

**9.3 — El script no tenía conexión en DBeaver.** Al guardarlo como archivo quedó sin base de datos asociada. Solución: `Ctrl + 9` y elegir `gisdb`.

## Preguntas de entrevista
- **¿Qué es un índice espacial y por qué mejora el rendimiento de las consultas?** Es una estructura (típicamente GiST) que permite descartar rápidamente las geometrías que claramente no cumplen una condición espacial, evitando comparar cada fila una por una.
- **¿Cuándo usarías geography en vez de geometry?** Cuando necesitas cálculos de distancia o área precisos sobre grandes extensiones (a nivel país o mundial), donde la curvatura de la Tierra afecta el resultado; para áreas pequeñas y mejor rendimiento, geometry con una proyección adecuada suele ser preferible.
- **¿Qué harías si PostGIS no reconoce el SRID de tus datos?** Revisaría `spatial_ref_sys`. En Manizales, EPSG:6256 no venía registrado porque su método de proyección no cabe en WKT1; lo registré con su definición WKT2 y PROJ, y lo validé reproyectando un punto conocido a WGS 84 y comparándolo con sus coordenadas originales.
- **¿Qué es un spatial join y cómo lo harías en SQL?** Es unir tablas por una relación espacial en lugar de un campo común. Por ejemplo, `JOIN comunas c ON ST_Contains(c.geom, a.geom)` asigna a cada activo la comuna que lo contiene; lo usé para verificar que los 5 activos estaban en la comuna registrada.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
- `hallazgos.md`: hallazgos de los 5 ejercicios, con sus capturas.
- `9.3-activos-geom.png`: activos con su geometría.
- `9.4-distancias.png`: distancias a la Universidad de Caldas.
- `9.5-diag-0` a `9.5-diag-6`: diagnóstico y solución de los problemas de CRS.
- `9.5-activos-postgis-qgis.png`: activos de PostGIS dibujados en QGIS sobre las comunas.
- `9.5-comunas-cargadas.png`, `9.5-verificacion-contains.png`: carga de comunas y verificación espacial.
- `sql/postgis.sql`: script del proyecto. `sql/comunas.sql`: carga de las comunas.
