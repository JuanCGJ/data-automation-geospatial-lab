-- =========================================================
-- Proyecto 8 — PostgreSQL desde cero
-- Base de datos: gisdb | Esquema: monitoreo
-- Monitoreo de activos conectados de Manizales
-- =========================================================

-- ===== 8.2 Estructura =====
CREATE SCHEMA IF NOT EXISTS monitoreo;

-- Tabla de activos (cámaras, postes, sensores)
CREATE TABLE IF NOT EXISTS monitoreo.activos (
    id_activo  SERIAL PRIMARY KEY,
    tipo       VARCHAR(30) NOT NULL,
    estado     VARCHAR(20) NOT NULL,
    comuna     VARCHAR(60)
);

-- Tabla de lecturas: muchas por cada activo
CREATE TABLE IF NOT EXISTS monitoreo.lecturas (
    id_lectura   SERIAL PRIMARY KEY,
    id_activo    INTEGER NOT NULL REFERENCES monitoreo.activos(id_activo),
    fecha        TIMESTAMP NOT NULL,
    senal_pct  NUMERIC(5,2)
);

-- Índice para acelerar consultas por fecha
CREATE INDEX IF NOT EXISTS idx_lecturas_fecha ON monitoreo.lecturas(fecha);

-- Nota: la columna se creó primero como bateria_pct y se renombró con:
-- ALTER TABLE monitoreo.lecturas RENAME COLUMN bateria_pct TO senal_pct;


-- ===== 8.3 Datos de prueba =====
INSERT INTO monitoreo.activos (tipo, estado, comuna) VALUES
    ('camara',            'activo',        'Palogrande'),
    ('camara',            'inactivo',      'Cumanday'),
    ('poste_inteligente', 'activo',        'San José'),
    ('poste_inteligente', 'activo',        'Estación'),
    ('sensor',            'mantenimiento', 'Nuevo Horizonte');


-- Lecturas: 3 por activo (12 al 14 de octubre), señal en %
-- Los activos 2 y 5 pierden señal día a día (casos para detectar en 8.4)
INSERT INTO monitoreo.lecturas (id_activo, fecha, senal_pct) VALUES
    -- 1: cámara Palogrande (estable, señal alta)
    (1, '2026-10-12 08:00', 95.00),
    (1, '2026-10-13 08:00', 93.00),
    (1, '2026-10-14 08:00', 91.00),
    -- 2: cámara Cumanday (inactiva, señal cayendo)
    (2, '2026-10-12 08:00', 40.00),
    (2, '2026-10-13 08:00', 22.00),
    (2, '2026-10-14 08:00', 15.00),
    -- 3: poste inteligente San José
    (3, '2026-10-12 08:00', 88.00),
    (3, '2026-10-13 08:00', 87.00),
    (3, '2026-10-14 08:00', 86.00),
    -- 4: poste inteligente Estación
    (4, '2026-10-12 08:00', 76.00),
    (4, '2026-10-13 08:00', 74.00),
    (4, '2026-10-14 08:00', 73.00),
    -- 5: sensor Nuevo Horizonte (en mantenimiento, señal crítica)
    (5, '2026-10-12 08:00', 30.00),
    (5, '2026-10-13 08:00', 18.00),
    (5, '2026-10-14 08:00',  9.00);


-- ===== 8.4 Consultas =====

-- Consulta 1 (filtro): lecturas con señal menor al 30 %
SELECT id_lectura, id_activo, fecha, senal_pct
FROM monitoreo.lecturas
WHERE senal_pct < 30
ORDER BY senal_pct;

-- Consulta 2 (JOIN): lecturas del 14 de octubre con el tipo y la comuna de cada activo
SELECT l.fecha, a.tipo, a.comuna, a.estado, l.senal_pct
FROM monitoreo.lecturas AS l
JOIN monitoreo.activos  AS a ON l.id_activo = a.id_activo
WHERE l.fecha::date = '2026-10-14'
ORDER BY l.senal_pct;

-- Consulta 3 (agregación): promedio, mínimo y número de lecturas por tipo de activo
SELECT a.tipo,
       COUNT(*)                   AS num_lecturas,
       ROUND(AVG(l.senal_pct), 2) AS senal_promedio,
       MIN(l.senal_pct)           AS senal_minima
FROM monitoreo.lecturas AS l
JOIN monitoreo.activos  AS a ON l.id_activo = a.id_activo
GROUP BY a.tipo
ORDER BY senal_promedio;

-- Consulta 4 (agregación + HAVING): activos cuya señal cayó más de 10 puntos
SELECT a.id_activo, a.tipo, a.comuna,
       MAX(l.senal_pct)                    AS senal_maxima,
       MIN(l.senal_pct)                    AS senal_minima,
       MAX(l.senal_pct) - MIN(l.senal_pct) AS caida
FROM monitoreo.lecturas AS l
JOIN monitoreo.activos  AS a ON l.id_activo = a.id_activo
GROUP BY a.id_activo, a.tipo, a.comuna
HAVING MAX(l.senal_pct) - MIN(l.senal_pct) > 10
ORDER BY caida DESC;

-- Consulta 5 (subconsulta + CASE): nivel de alerta de cada activo en la última lectura
SELECT a.id_activo, a.tipo, a.comuna, l.senal_pct,
       CASE
           WHEN l.senal_pct < 20 THEN 'CRITICA'
           WHEN l.senal_pct < 50 THEN 'BAJA'
           ELSE 'OK'
       END AS alerta
FROM monitoreo.lecturas AS l
JOIN monitoreo.activos  AS a ON l.id_activo = a.id_activo
WHERE l.fecha = (SELECT MAX(fecha) FROM monitoreo.lecturas)
ORDER BY l.senal_pct;
