-- =========================================================
-- Proyecto 14 — Capstone
-- Comunas en alerta sin cobertura (14.8)
-- Base de datos: gisdb | Esquema: plataforma
--
-- Ejecutar cada bloque por separado: seleccionarlo con el mouse
-- y presionar Ctrl + Enter (no usar Alt + X).
-- =========================================================


-- ===== 14.8 Cobertura de las comunas en alerta (solo lectura) =====
-- Regla: una comuna en alerta está CUBIERTA si al menos una brigada activa
-- reportó, en los últimos 60 minutos, una posición a menos de 1 km de la comuna.
WITH ultimas AS (
    -- 1) Última posición de cada brigada activa, si es de los últimos 60 minutos.
    --    DISTINCT ON deja una sola fila por brigada: la primera del ORDER BY (la más reciente).
    SELECT DISTINCT ON (p.id_brigada)
           p.id_brigada, b.nombre, p.geom, p.registrado_en
    FROM plataforma.posiciones p
    JOIN plataforma.brigadas b ON b.id_brigada = p.id_brigada AND b.activa
    WHERE p.registrado_en >= now() - INTERVAL '60 minutes'
    ORDER BY p.id_brigada, p.registrado_en DESC
),
en_alerta AS (
    -- 2) Comunas con alerta por lluvia hoy (fecha en hora de Colombia; PostgreSQL corre en UTC).
    SELECT a.id_comuna
    FROM plataforma.alertas a
    WHERE a.tipo = 'riesgo_lluvia'
      AND a.fecha = (now() AT TIME ZONE 'America/Bogota')::date
)
-- 3) Para cada comuna en alerta: cuántas brigadas hay a menos de 1000 m (EPSG:6256 está en metros).
--    Se mide contra el polígono: una brigada dentro de la comuna tiene distancia 0.
SELECT cr.id_comuna,
       cr.nombre,
       cr.nivel,
       COUNT(u.id_brigada)                                    AS brigadas_a_1km,
       STRING_AGG(u.nombre, ', ' ORDER BY u.id_brigada)       AS cuales,
       (SELECT ROUND(MIN(ST_Distance(cr.geom, u2.geom))::numeric)
        FROM ultimas u2)                                      AS m_brigada_mas_cercana
FROM en_alerta e
JOIN plataforma.comunas_riesgo cr ON cr.id_comuna = e.id_comuna
LEFT JOIN ultimas u ON ST_DWithin(cr.geom, u.geom, 1000)    -- LEFT JOIN: las comunas sin brigada salen con 0
GROUP BY cr.id_comuna, cr.nombre, cr.nivel, cr.geom
ORDER BY brigadas_a_1km, cr.id_comuna;                      -- primero las comunas sin cobertura

-- ===== 14.8 Registrar alertas "sin_cobertura" =====
-- Inserta una alerta por cada comuna en alerta por lluvia HOY que no tiene ninguna
-- brigada activa (posición de los últimos 60 min) a menos de 1 km.
-- Upsert: si se ejecuta otra vez el mismo día, actualiza el detalle en lugar de duplicar.
WITH ultimas AS (
    -- Última posición de cada brigada activa, si es de los últimos 60 minutos
    SELECT DISTINCT ON (p.id_brigada)
           p.id_brigada, p.geom
    FROM plataforma.posiciones p
    JOIN plataforma.brigadas b ON b.id_brigada = p.id_brigada AND b.activa
    WHERE p.registrado_en >= now() - INTERVAL '60 minutes'
    ORDER BY p.id_brigada, p.registrado_en DESC
),
sin_cobertura AS (
    -- Comunas en alerta por lluvia hoy SIN ninguna brigada a menos de 1000 m
    SELECT a.id_comuna, a.fecha, a.a25_mm, a.umbral_mm,
           (SELECT ROUND(MIN(ST_Distance(cr.geom, u2.geom))::numeric)
            FROM ultimas u2) AS m_mas_cercana                -- NULL si ninguna brigada reportó
    FROM plataforma.alertas a
    JOIN plataforma.comunas_riesgo cr ON cr.id_comuna = a.id_comuna
    WHERE a.tipo = 'riesgo_lluvia'
      AND a.fecha = (now() AT TIME ZONE 'America/Bogota')::date
      AND NOT EXISTS (SELECT 1 FROM ultimas u
                      WHERE ST_DWithin(cr.geom, u.geom, 1000))
)
INSERT INTO plataforma.alertas (tipo, id_comuna, fecha, a25_mm, umbral_mm, detalle)
SELECT 'sin_cobertura', id_comuna, fecha, a25_mm, umbral_mm,
       CASE WHEN m_mas_cercana IS NULL
            THEN 'Ninguna brigada activa reportó en los últimos 60 min'
            ELSE 'Sin brigada activa a menos de 1 km; la más cercana a ' || m_mas_cercana || ' m'
       END
FROM sin_cobertura
ON CONFLICT (tipo, id_comuna, fecha) DO UPDATE
    SET detalle = EXCLUDED.detalle,
        creado_en = now()
RETURNING id, tipo, id_comuna, fecha, a25_mm, umbral_mm, detalle;


-- ===== 14.8 Prueba: sacar de servicio la Brigada Occidente =====
-- Simula una brigada varada o atendiendo otra emergencia, para probar la alerta "sin_cobertura".
-- La consulta de cobertura solo cuenta brigadas activas (JOIN ... AND b.activa).
-- IMPORTANTE: al terminar la prueba, ejecutar el bloque "Volver a activar la Brigada Occidente".
UPDATE plataforma.brigadas
SET activa = false
WHERE id_brigada = 3                -- 3 = Brigada Occidente
RETURNING id_brigada, nombre, activa;


-- ===== 14.8 Volver a activar la Brigada Occidente =====
-- Ejecutar al terminar la prueba, para dejar las 4 brigadas activas.
UPDATE plataforma.brigadas
SET activa = true
WHERE id_brigada = 3
RETURNING id_brigada, nombre, activa;