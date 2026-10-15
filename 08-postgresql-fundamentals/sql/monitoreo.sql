
-- =========================================================
-- Proyecto 8 — PostgreSQL desde cero
-- Base de datos: gisdb | Esquema: monitoreo
-- Monitoreo de activos conectados de Manizales
-- =========================================================

-- ===== 8.2 Estructura =====CREATE SCHEMA IF NOT EXISTS monitoreo;

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


