-- =====================================================================
-- Proyecto 11 — n8n + PostgreSQL
-- Tabla destino del workflow "Weather to PostgreSQL" (Open-Meteo → n8n → PostgreSQL)
-- Base de datos: gisdb | Esquema: monitoreo
-- =====================================================================

CREATE TABLE IF NOT EXISTS monitoreo.clima_open_meteo (
    id             SERIAL PRIMARY KEY,
    ciudad         TEXT NOT NULL,
    fecha_hora     TIMESTAMPTZ NOT NULL,      -- hora de la medición (Open-Meteo, con zona explícita desde n8n)
    temperatura_c  NUMERIC(5,2),
    humedad_pct    NUMERIC(5,2),
    viento_kmh     NUMERIC(5,2),
    creado_en      TIMESTAMPTZ DEFAULT now()  -- hora de inserción (la asigna PostgreSQL)
);

-- ---------------------------------------------------------------------
-- Corrección aplicada en la 11.4 (la tabla se creó primero con TIMESTAMP).
-- Solo es necesaria si la tabla ya existía con TIMESTAMP; el USING indica
-- en qué zona estaba cada valor guardado para no desplazar la hora.
-- ---------------------------------------------------------------------
-- ALTER TABLE monitoreo.clima_open_meteo
--   ALTER COLUMN fecha_hora TYPE TIMESTAMPTZ USING fecha_hora AT TIME ZONE 'America/Bogota',
--   ALTER COLUMN creado_en  TYPE TIMESTAMPTZ USING creado_en  AT TIME ZONE 'UTC';

-- Verificación (11.4)
SELECT * FROM monitoreo.clima_open_meteo ORDER BY id DESC;
