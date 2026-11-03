CREATE TABLE monitoreo.clima_open_meteo (
    id             SERIAL PRIMARY KEY,
    ciudad         TEXT NOT NULL,
    fecha_hora     TIMESTAMP NOT NULL,
    temperatura_c  NUMERIC(5,2),
    humedad_pct    NUMERIC(5,2),
    viento_kmh     NUMERIC(5,2),
    creado_en      TIMESTAMP DEFAULT now()
);
