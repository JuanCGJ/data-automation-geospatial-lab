-- =========================================================
-- Proyecto 12 — n8n + PostGIS (Geofencing)
-- Base de datos: gisdb | Esquema: monitoreo | CRS: EPSG:6256
-- Requisito: tabla monitoreo.comunas del Proyecto 9 (9.5)
-- Las coordenadas llegan en WGS 84 (EPSG:4326), como las envía un GPS
-- =========================================================


-- ===== 12.3 Validar una coordenada con ST_Contains =====
-- ST_MakePoint(lon, lat): primero longitud (x), luego latitud (y)
-- ST_SetSRID(..., 4326): las coordenadas son WGS 84
-- ST_Transform(..., 6256): se pasan al CRS de las comunas
-- LEFT JOIN: siempre devuelve una fila (comuna = NULL si el punto está fuera)

-- Punto dentro: Catedral Basílica (esperado: Comuna Cumanday, dentro = true)
SELECT
    c.nombre             AS comuna,
    c.nombre IS NOT NULL AS dentro
FROM (
    SELECT ST_Transform(ST_SetSRID(ST_MakePoint(-75.5174, 5.0685), 4326), 6256) AS geom
) p
LEFT JOIN monitoreo.comunas c ON ST_Contains(c.geom, p.geom);

-- Punto fuera, caso de borde: Villamaría (esperado: comuna = NULL, dentro = false)
SELECT
    c.nombre             AS comuna,
    c.nombre IS NOT NULL AS dentro
FROM (
    SELECT ST_Transform(ST_SetSRID(ST_MakePoint(-75.5145, 5.0447), 4326), 6256) AS geom
) p
LEFT JOIN monitoreo.comunas c ON ST_Contains(c.geom, p.geom);


-- Verificación de las 9 coordenadas de prueba (data/coordenadas_prueba.csv)
-- La columna "acierta" debe ser true en todas las filas
WITH puntos (id, nombre, lat, lon, esperado) AS (
    VALUES
        (1, 'Catedral Basilica',             5.0685, -75.5174, 'dentro'),
        (2, 'Monumento a los Colonizadores', 5.0726, -75.5284, 'dentro'),
        (3, 'Universidad de Caldas',         5.0560, -75.4930, 'dentro'),
        (4, 'Estadio Palogrande',            5.0555, -75.4890, 'dentro'),
        (5, 'Ecoparque Los Yarumos',         5.0640, -75.4810, 'dentro'),
        (6, 'Villamaria (parque principal)', 5.0447, -75.5145, 'fuera'),
        (7, 'Chinchina',                     4.9826, -75.6036, 'fuera'),
        (8, 'Pereira',                       4.8133, -75.6961, 'fuera'),
        (9, 'Bogota',                        4.6097, -74.0817, 'fuera')
)
SELECT
    p.id,
    p.nombre,
    c.nombre                                              AS comuna,
    CASE WHEN c.nombre IS NOT NULL THEN 'dentro' ELSE 'fuera' END AS resultado,
    p.esperado,
    (CASE WHEN c.nombre IS NOT NULL THEN 'dentro' ELSE 'fuera' END) = p.esperado AS acierta
FROM puntos p
LEFT JOIN monitoreo.comunas c
    ON ST_Contains(c.geom, ST_Transform(ST_SetSRID(ST_MakePoint(p.lon, p.lat), 4326), 6256))
ORDER BY p.id;


-- ===== 12.4 Tabla de alertas =====
-- Una fila por cada coordenada recibida fuera de las comunas
CREATE TABLE IF NOT EXISTS monitoreo.alertas_geofence (
    id         SERIAL PRIMARY KEY,
    nombre     TEXT,
    lat        NUMERIC(9,6) NOT NULL,
    lon        NUMERIC(9,6) NOT NULL,
    geom       geometry(Point, 6256),          -- punto ya transformado al CRS de las comunas
    creado_en  TIMESTAMPTZ DEFAULT now()       -- hora de la alerta (con zona, como en el Proyecto 11)
);

-- Verificación: alertas registradas por n8n (esperado: solo puntos fuera)
SELECT id, nombre, lat, lon, ST_AsText(geom) AS geom_6256, creado_en
FROM monitoreo.alertas_geofence
ORDER BY id;

-- Limpieza: borra todas las alertas de prueba y reinicia el contador del id
-- (comentado para no ejecutarlo por accidente; no se puede deshacer)
-- TRUNCATE TABLE monitoreo.alertas_geofence RESTART IDENTITY;
