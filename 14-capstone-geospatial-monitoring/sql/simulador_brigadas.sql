-- =========================================================
-- Proyecto 14 — Capstone
-- Simulador de brigadas (14.6) y workflow de posiciones (14.7)
-- Base de datos: gisdb | Esquema: plataforma
--
-- IMPORTANTE: NO ejecutar el script completo (Alt + X).
-- Los bloques 14.7 insertan filas de prueba y el último vacía la tabla.
-- Ejecutar cada bloque por separado: seleccionarlo con el mouse
-- (de WITH/SELECT hasta el ;) y presionar Ctrl + Enter.
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


-- ===== 14.7 Prueba 1: posición DENTRO de una comuna =====
-- n8n usará esta misma consulta, cambiando los valores fijos por $1..$4.
-- Prueba: Brigada Norte (1) sobre el punto interior de la comuna 2 (San José).
-- Esperado: id_brigada = 1, id_comuna = 2.
WITH punto AS (
    SELECT 1::smallint AS id_brigada,
           -- GPS → EPSG:4326 (grados) → EPSG:6256 (metros, CRS de las comunas).
           -- ST_MakePoint recibe primero la longitud (x) y luego la latitud (y).
           ST_Transform(ST_SetSRID(ST_MakePoint(-75.5144, 5.0748), 4326), 6256) AS geom,
           '2026-11-19T16:35:00-05:00'::timestamptz AS registrado_en
)
INSERT INTO plataforma.posiciones (id_brigada, id_comuna, geom, registrado_en)
SELECT p.id_brigada,
       cr.id_comuna,              -- NULL si el punto no cae en ninguna comuna
       p.geom,
       p.registrado_en
FROM punto p
LEFT JOIN plataforma.comunas_riesgo cr ON ST_Contains(cr.geom, p.geom)
LIMIT 1                           -- si un punto cae justo en el borde de dos comunas, guarda solo una fila
RETURNING id, id_brigada, id_comuna,
          ST_AsText(ST_Transform(geom, 4326)) AS punto_wgs84,   -- texto legible en lugar del binario
          registrado_en;


-- ===== 14.7 Prueba 2: posición FUERA de las comunas =====
-- Prueba: Brigada Centro (2) en el parque principal de Villamaría, fuera de Manizales.
-- Esperado: id_brigada = 2, id_comuna NULL (la fila SÍ se guarda, gracias al LEFT JOIN).
WITH punto AS (
    SELECT 2::smallint AS id_brigada,
           ST_Transform(ST_SetSRID(ST_MakePoint(-75.5145, 5.0447), 4326), 6256) AS geom,
           '2026-11-19T16:50:00-05:00'::timestamptz AS registrado_en
)
INSERT INTO plataforma.posiciones (id_brigada, id_comuna, geom, registrado_en)
SELECT p.id_brigada,
       cr.id_comuna,              -- NULL si el punto no cae en ninguna comuna
       p.geom,
       p.registrado_en
FROM punto p
LEFT JOIN plataforma.comunas_riesgo cr ON ST_Contains(cr.geom, p.geom)
LIMIT 1
RETURNING id, id_brigada, id_comuna,
          ST_AsText(ST_Transform(geom, 4326)) AS punto_wgs84,
          registrado_en;


-- ===== 14.7 Ver las posiciones guardadas =====
-- Solo lectura: muestra cada posición con el nombre de la brigada y de la comuna.
-- LEFT JOIN con comunas para mostrar también las posiciones fuera (comuna vacía).
SELECT p.id,
       b.nombre  AS brigada,
       p.id_comuna,
       c.nombre  AS comuna,
       ST_AsText(ST_Transform(p.geom, 4326)) AS punto_wgs84,
       p.registrado_en
FROM plataforma.posiciones p
JOIN plataforma.brigadas b             ON b.id_brigada = p.id_brigada
LEFT JOIN plataforma.comunas_riesgo c  ON c.id_comuna  = p.id_comuna
ORDER BY p.id;


-- ===== 14.7 Limpiar las posiciones de prueba =====
-- CUIDADO: borra TODAS las posiciones. Usar solo para quitar las pruebas
-- antes de conectar el simulador. RESTART IDENTITY reinicia el id en 1.
TRUNCATE plataforma.posiciones RESTART IDENTITY;
