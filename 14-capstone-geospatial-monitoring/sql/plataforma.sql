-- =========================================================
-- Proyecto 14 — Capstone: Sistema de alerta temprana por deslizamientos
-- Esquema plataforma: modelo de datos del sistema
-- Base de datos: gisdb | CRS: EPSG:6256
-- Lee (sin modificar): monitoreo.comunas, monitoreo.comunas_centroides
-- Requisitos (Proyecto 9): EPSG:6256 registrado en spatial_ref_sys y
-- monitoreo.comunas cargada (09-postgis/sql/). Sin ellos, este script falla.
-- =========================================================


-- ===== 14.4 Esquema =====
-- IF NOT EXISTS: si el esquema ya existe, no da error (el script se puede ejecutar varias veces)
CREATE SCHEMA IF NOT EXISTS plataforma;


-- ===== 14.4 Umbrales de lluvia A25 por nivel =====
-- Una fila por nivel: si cambia un umbral, se edita una sola fila (normalización)
CREATE TABLE IF NOT EXISTS plataforma.umbrales (
    nivel      TEXT PRIMARY KEY CHECK (nivel IN ('alta', 'media', 'baja')),
    umbral_mm  NUMERIC(5,1) NOT NULL CHECK (umbral_mm > 0),
    fuente     TEXT NOT NULL
);

INSERT INTO plataforma.umbrales (nivel, umbral_mm, fuente) VALUES
    ('alta',  150, 'Supuesto del proyecto'),
    ('media', 200, 'Oficial OMPAD (IDEA - UNAL)'),
    ('baja',  250, 'Supuesto del proyecto')
ON CONFLICT (nivel) DO NOTHING;


-- ===== 14.4 Nivel de susceptibilidad por comuna (resultado del 14.3) =====
CREATE TABLE IF NOT EXISTS plataforma.comunas_riesgo (
    id_comuna  INTEGER PRIMARY KEY,
    nombre     TEXT NOT NULL,
    pct_alta   NUMERIC(4,1) NOT NULL CHECK (pct_alta BETWEEN 0 AND 100),  -- % del área en alta + muy alta (SGC)
    nivel_sgc  TEXT NOT NULL CHECK (nivel_sgc IN ('alta', 'media', 'baja')), -- nivel según el dato oficial
    nivel      TEXT NOT NULL REFERENCES plataforma.umbrales (nivel),         -- nivel final (con ajuste)
    ajuste     TEXT,                                                         -- motivo del ajuste; NULL si no hubo
    geom       geometry(MultiPolygon, 6256) NOT NULL
);

-- Índice espacial (Proyecto 9): acelera ST_Contains y ST_DWithin
CREATE INDEX IF NOT EXISTS idx_comunas_riesgo_geom
    ON plataforma.comunas_riesgo USING GIST (geom);


-- ===== 14.4 Brigadas de emergencia =====
CREATE TABLE IF NOT EXISTS plataforma.brigadas (
    id_brigada  SMALLINT PRIMARY KEY,
    nombre      TEXT NOT NULL UNIQUE,
    activa      BOOLEAN NOT NULL DEFAULT true
);

-- 4 brigadas ficticias para la simulación (14.6)
INSERT INTO plataforma.brigadas (id_brigada, nombre) VALUES
    (1, 'Brigada Norte'),
    (2, 'Brigada Centro'),
    (3, 'Brigada Occidente'),
    (4, 'Brigada Oriente')
ON CONFLICT (id_brigada) DO NOTHING;


-- ===== 14.4 Posiciones reportadas por las brigadas =====
-- Una fila por reporte (crece continuamente). La llena n8n (14.7).
CREATE TABLE IF NOT EXISTS plataforma.posiciones (
    id             BIGSERIAL PRIMARY KEY,
    id_brigada     SMALLINT NOT NULL REFERENCES plataforma.brigadas (id_brigada),
    id_comuna      INTEGER REFERENCES plataforma.comunas_riesgo (id_comuna),  -- NULL si está fuera de las comunas
    geom           geometry(Point, 6256) NOT NULL,
    registrado_en  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Índice espacial: cobertura con ST_DWithin (14.8)
CREATE INDEX IF NOT EXISTS idx_posiciones_geom
    ON plataforma.posiciones USING GIST (geom);

-- Índice para "última posición de cada brigada"
CREATE INDEX IF NOT EXISTS idx_posiciones_brigada_fecha
    ON plataforma.posiciones (id_brigada, registrado_en DESC);


-- ===== 14.4 Lluvia acumulada A25 por comuna =====
-- A25 = lluvia de los últimos 25 días (indicador de OMPAD). La llena n8n (14.5).
CREATE TABLE IF NOT EXISTS plataforma.lluvia_a25 (
    id             BIGSERIAL PRIMARY KEY,
    id_comuna      INTEGER NOT NULL REFERENCES plataforma.comunas_riesgo (id_comuna),
    fecha          DATE NOT NULL,                                -- día del cálculo
    a25_mm         NUMERIC(6,1) NOT NULL CHECK (a25_mm >= 0),
    consultado_en  TIMESTAMPTZ NOT NULL DEFAULT now(),           -- cuándo se consultó Open-Meteo
    UNIQUE (id_comuna, fecha)                                    -- un A25 por comuna y día
);


-- ===== 14.4 Alertas =====
-- tipo 'riesgo_lluvia': el A25 supera el umbral de la comuna (14.5)
-- tipo 'sin_cobertura': comuna en alerta sin brigada cercana (14.8)
CREATE TABLE IF NOT EXISTS plataforma.alertas (
    id         BIGSERIAL PRIMARY KEY,
    tipo       TEXT NOT NULL CHECK (tipo IN ('riesgo_lluvia', 'sin_cobertura')),
    id_comuna  INTEGER NOT NULL REFERENCES plataforma.comunas_riesgo (id_comuna),
    fecha      DATE NOT NULL,
    a25_mm     NUMERIC(6,1),          -- lluvia que disparó la alerta
    umbral_mm  NUMERIC(5,1),          -- umbral vigente en ese momento (queda registrado aunque luego cambie)
    detalle    TEXT,                  -- información adicional (p. ej. brigada más cercana y su distancia)
    creado_en  TIMESTAMPTZ NOT NULL DEFAULT now(),
    UNIQUE (tipo, id_comuna, fecha)   -- una alerta de cada tipo por comuna y día
);


-- ===== 14.4 Carga del nivel por comuna (resultado del 14.3) =====
-- Atributos: data/comunas_susceptibilidad_hist.gpkg (14.3).
-- Geometría y nombre: monitoreo.comunas (ya en PostGIS con SRID 6256).
-- No se importa el GeoPackage con QGIS: su CRS 6256 quedó "undefined" y DB Manager
-- falla con "SRID must be <= 998999" (mismo problema del Proyecto 9, ver 09-postgis/problemas-srid.md).
WITH resultado_14_3 (id_comuna, pct_alta, nivel_sgc, nivel, ajuste) AS (
    VALUES
        ( 1, 27.7, 'media', 'alta',  'Sector occidental, el mas lluvioso (IDEA - UNAL)'),   -- Atardeceres
        ( 2, 10.6, 'baja',  'media', 'Ladera de Olivares, deslizamientos historicos'),      -- San José
        ( 3,  0.2, 'baja',  'baja',  NULL),                                                 -- Cumanday
        ( 4,  2.6, 'baja',  'baja',  NULL),                                                 -- Estación
        ( 5, 25.5, 'media', 'media', NULL),                                                 -- Ciudadela del Norte
        ( 6, 26.6, 'media', 'media', NULL),                                                 -- Ecoturístico Cerro de Oro
        ( 7, 93.1, 'alta',  'alta',  NULL),                                                 -- Tesorito
        ( 8, 43.7, 'alta',  'alta',  NULL),                                                 -- Palogrande
        ( 9, 75.4, 'alta',  'alta',  NULL),                                                 -- Universitaria
        (10,  9.4, 'baja',  'baja',  NULL),                                                 -- La Fuente
        (11, 29.1, 'media', 'alta',  'Sector occidental, el mas lluvioso (IDEA - UNAL)'),   -- La Macarena
        (12,  6.5, 'baja',  'baja',  NULL)                                                  -- Nuevo Horizonte
)
INSERT INTO plataforma.comunas_riesgo (id_comuna, nombre, pct_alta, nivel_sgc, nivel, ajuste, geom)
SELECT r.id_comuna, c.nombre, r.pct_alta, r.nivel_sgc, r.nivel, r.ajuste, c.geom
FROM resultado_14_3 r
JOIN monitoreo.comunas c ON c.id_comuna = r.id_comuna
ON CONFLICT (id_comuna) DO UPDATE SET
    nombre    = EXCLUDED.nombre,
    pct_alta  = EXCLUDED.pct_alta,
    nivel_sgc = EXCLUDED.nivel_sgc,
    nivel     = EXCLUDED.nivel,
    ajuste    = EXCLUDED.ajuste,
    geom      = EXCLUDED.geom;


-- ===== 14.4 Verificación: nivel y umbral por comuna (esperado: 12 filas) =====
SELECT cr.id_comuna, cr.nombre, cr.pct_alta, cr.nivel_sgc, cr.nivel, u.umbral_mm, cr.ajuste,
       ST_SRID(cr.geom) AS srid
FROM plataforma.comunas_riesgo cr
JOIN plataforma.umbrales u ON u.nivel = cr.nivel
ORDER BY cr.id_comuna;


-- ===== 14.4 Verificación: tablas del esquema plataforma (esperado: 6) =====
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'plataforma'
ORDER BY table_name;
