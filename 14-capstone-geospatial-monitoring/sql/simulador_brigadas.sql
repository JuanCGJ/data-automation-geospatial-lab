-- =========================================================
-- Proyecto 14 — Capstone
-- Simulador de brigadas (14.6): consultas de apoyo
-- Base de datos: gisdb | Esquema: plataforma
-- =========================================================


-- ===== 14.6 Punto interior de cada comuna, de occidente a oriente =====
-- Sirve para repartir las comunas entre las 4 brigadas según su ubicación.
-- Latitud mayor = más al norte; longitud menos negativa = más al oriente.
SELECT cr.id_comuna,
       cr.nombre,
       ROUND(ST_Y(ST_Transform(cc.geom, 4326))::numeric, 4) AS lat,
       ROUND(ST_X(ST_Transform(cc.geom, 4326))::numeric, 4) AS lon
FROM plataforma.comunas_riesgo cr
JOIN monitoreo.comunas_centroides cc ON cc.id_comuna = cr.id_comuna
                                    AND cc.tipo = 'punto_interior'
ORDER BY lon;   -- ordenadas de occidente a oriente