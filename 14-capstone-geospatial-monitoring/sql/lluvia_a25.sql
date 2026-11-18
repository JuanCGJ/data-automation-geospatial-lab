-- =========================================================
-- Proyecto 14 — Capstone
-- Workflow de lluvia A25 (14.5): consultas que usa n8n
-- Base de datos: gisdb | Esquema: plataforma
-- =========================================================


-- ===== 14.5 Punto interior de cada comuna en latitud/longitud =====
-- Open-Meteo pide coordenadas WGS 84 (EPSG:4326); los puntos están en EPSG:6256 (metros).
-- Se usa el punto interior (Proyecto 13) porque siempre cae dentro de la comuna.
SELECT cr.id_comuna,
       cr.nombre,
       cr.nivel,
       u.umbral_mm,
       ROUND(ST_Y(ST_Transform(cc.geom, 4326))::numeric, 4) AS lat,
       ROUND(ST_X(ST_Transform(cc.geom, 4326))::numeric, 4) AS lon
FROM plataforma.comunas_riesgo cr
JOIN plataforma.umbrales u          ON u.nivel = cr.nivel
JOIN monitoreo.comunas_centroides cc ON cc.id_comuna = cr.id_comuna
                                    AND cc.tipo = 'punto_interior'
ORDER BY cr.id_comuna;

-- ===== 14.5 Verificación: lluvia A25 guardada hoy =====
-- Se usa la fecha en hora de Colombia, porque PostgreSQL corre en UTC
-- y de noche CURRENT_DATE ya sería el día siguiente.
-- Esperado: 12 filas, una por comuna.
SELECT l.id_comuna, cr.nombre, l.fecha, l.a25_mm, l.consultado_en
FROM plataforma.lluvia_a25 l
JOIN plataforma.comunas_riesgo cr ON cr.id_comuna = l.id_comuna
WHERE l.fecha = (now() AT TIME ZONE 'America/Bogota')::date
ORDER BY l.id_comuna;

-- ===== 14.5 Verificación: alertas de lluvia de hoy =====
-- Compara la lluvia acumulada (a25_mm) con el umbral del nivel de la comuna.
-- Esperado: 12 filas de tipo 'riesgo_lluvia'.
SELECT a.id, a.id_comuna, cr.nombre, cr.nivel, a.fecha,
       a.a25_mm, a.umbral_mm, a.a25_mm - a.umbral_mm AS exceso_mm
FROM plataforma.alertas a
JOIN plataforma.comunas_riesgo cr ON cr.id_comuna = a.id_comuna
WHERE a.tipo = 'riesgo_lluvia'
  AND a.fecha = (now() AT TIME ZONE 'America/Bogota')::date
ORDER BY a.id_comuna;