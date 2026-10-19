-- =========================================================
-- Proyecto 9 — PostGIS
-- Base de datos: gisdb | Esquema: monitoreo | CRS: EPSG:6256
-- =========================================================

-- ===== 9.3 Columna geométrica =====
ALTER TABLE monitoreo.activos
    ADD COLUMN IF NOT EXISTS geom geometry(Point, 6256);

CREATE INDEX IF NOT EXISTS idx_activos_geom
    ON monitoreo.activos USING GIST (geom);

-- Ubicación de cada activo (EPSG:6256, metros). x = este, y = norte
-- Cada punto cae dentro de la comuna indicada en la columna "comuna"
UPDATE monitoreo.activos SET geom = ST_SetSRID(ST_MakePoint(1176191, 1050630), 6256) WHERE id_activo = 1; -- Palogrande
UPDATE monitoreo.activos SET geom = ST_SetSRID(ST_MakePoint(1173174, 1052302), 6256) WHERE id_activo = 2; -- Cumanday
UPDATE monitoreo.activos SET geom = ST_SetSRID(ST_MakePoint(1173356, 1053121), 6256) WHERE id_activo = 3; -- San José
UPDATE monitoreo.activos SET geom = ST_SetSRID(ST_MakePoint(1175024, 1052064), 6256) WHERE id_activo = 4; -- Estación
UPDATE monitoreo.activos SET geom = ST_SetSRID(ST_MakePoint(1176408, 1052900), 6256) WHERE id_activo = 5; -- Nuevo Horizonte

SELECT id_activo, tipo, comuna, ST_AsText(geom) AS ubicacion
FROM monitoreo.activos;


-- ===== 9.4 Consultas espaciales =====

-- Distancia de cada activo a la Universidad de Caldas y si está a menos de 1 km
WITH universidad AS (
    SELECT ST_SetSRID(ST_MakePoint(1175734, 1051047), 6256) AS geom
)
SELECT a.id_activo, a.tipo, a.comuna,
       ROUND(ST_Distance(a.geom, u.geom)) AS distancia_m,
       ST_DWithin(a.geom, u.geom, 1000)   AS a_menos_de_1km
FROM monitoreo.activos AS a, universidad AS u
ORDER BY distancia_m;


-- ===== 9.5 Problema: QGIS mostraba "activos" sin CRS =====
-- Síntoma: al cargar monitoreo.activos en QGIS aparecía el aviso
-- "Layer has no coordinate reference system set" y los puntos
-- no se alineaban con las comunas.

-- Diagnóstico 1: ¿qué SRID tienen guardado los puntos?  → 6256 (correcto)
SELECT DISTINCT ST_SRID(geom) FROM monitoreo.activos;

-- Diagnóstico 2: ¿PostGIS conoce el SRID 6256?  → sin filas (causa del problema)
SELECT srid, auth_name, auth_srid
FROM spatial_ref_sys
WHERE srid = 6256;

-- Causa: EPSG:6256 usa el método "Colombia Urban", que no se puede escribir en
-- WKT1; por eso PostGIS no lo incluye en spatial_ref_sys al instalarse.

-- Solución: registrar EPSG:6256 manualmente (idempotente con ON CONFLICT)
INSERT INTO spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text)
VALUES (
  6256, 'EPSG', 6256,
  'PROJCRS["MAGNA-SIRGAS / Manizales urban grid",BASEGEOGCRS["MAGNA-SIRGAS",DATUM["Marco Geocentrico Nacional de Referencia",ELLIPSOID["GRS 1980",6378137,298.257222101,LENGTHUNIT["metre",1]]],PRIMEM["Greenwich",0,ANGLEUNIT["degree",0.0174532925199433]],ID["EPSG",4686]],CONVERSION["Manizales urban grid",METHOD["Colombia Urban",ID["EPSG",1052]],PARAMETER["Latitude of natural origin",5.06815388888889,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8801]],PARAMETER["Longitude of natural origin",-75.5110947222222,ANGLEUNIT["degree",0.0174532925199433],ID["EPSG",8802]],PARAMETER["False easting",1173727.04,LENGTHUNIT["metre",1],ID["EPSG",8806]],PARAMETER["False northing",1052391.13,LENGTHUNIT["metre",1],ID["EPSG",8807]],PARAMETER["Projection plane origin height",2100,LENGTHUNIT["metre",1],ID["EPSG",1039]]],CS[Cartesian,2],AXIS["northing (N)",north,ORDER[1],LENGTHUNIT["metre",1]],AXIS["easting (E)",east,ORDER[2],LENGTHUNIT["metre",1]],USAGE[SCOPE["Cadastre, engineering survey, topographic mapping (large scale)."],AREA["Colombia - Manizales city."],BBOX[5.02,-75.54,5.11,-75.44]],ID["EPSG",6256]]',
  '+proj=col_urban +lat_0=5.06815388888889 +lon_0=-75.5110947222222 +x_0=1173727.04 +y_0=1052391.13 +h_0=2100 +ellps=GRS80 +units=m +no_defs'
)
ON CONFLICT (srid) DO NOTHING;

-- Diagnóstico: ¿PostGIS conoce el SRID 6256?  → sin filas (causa del problema)
SELECT srid, auth_name, auth_srid
FROM spatial_ref_sys
WHERE srid = 6256;

-- Verificación: la universidad, de metros (6256) a grados (4326).
-- Debe dar las coordenadas originales del CSV del Proyecto 2: (-75.493, 5.056)
SELECT ST_AsText(
  ST_Transform(ST_SetSRID(ST_MakePoint(1175734, 1051047), 6256), 4326)
);


-- ===== 9.5 Verificación espacial =====
-- ¿En qué comuna cae cada activo? Se compara con la comuna registrada en el Proyecto 8
SELECT a.id_activo, a.tipo,
       a.comuna                             AS comuna_registrada,
       c.nombre                             AS comuna_espacial,
       c.nombre ILIKE '%' || a.comuna || '%' AS coincide
FROM monitoreo.activos  AS a
JOIN monitoreo.comunas  AS c ON ST_Contains(c.geom, a.geom)
ORDER BY a.id_activo;