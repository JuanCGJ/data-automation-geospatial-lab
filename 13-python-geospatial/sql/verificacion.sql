-- =========================================================
-- Proyecto 13 — Python + datos geoespaciales
-- Verificación en DBeaver de la tabla escrita desde Python
-- Base de datos: gisdb | Esquema: monitoreo | CRS: EPSG:6256
-- Requisito: ejecutar antes scripts/comunas_centroides.py
-- =========================================================


-- ===== 13.4 Resumen por tipo de punto =====
-- Esperado: centroide → 12 puntos, 2 fuera | punto_interior → 12 puntos, 0 fuera | SRID 6256
-- COUNT(*) FILTER (WHERE ...) cuenta solo las filas que cumplen la condición
SELECT tipo,
       COUNT(*)                                    AS puntos,
       COUNT(*) FILTER (WHERE NOT dentro_de_comuna) AS fuera,
       ST_SRID(MIN(geom))                          AS srid
FROM monitoreo.comunas_centroides
GROUP BY tipo;

-- ===== 13.4 Centroides que quedan fuera de su comuna =====
-- Esperado: comunas 1 (Atardeceres) y 5 (Ciudadela del Norte)
SELECT id_comuna, nombre, tipo, ST_AsText(geom) AS geom_6256
FROM monitoreo.comunas_centroides
WHERE NOT dentro_de_comuna
ORDER BY id_comuna;
