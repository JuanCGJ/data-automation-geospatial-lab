"""
Proyecto 13 — Python + datos geoespaciales
==========================================
Lee las comunas de Manizales desde PostGIS con geopandas, calcula sus
centroides y compara el área calculada con el campo area_km2 (Proyecto 4).

Cómo ejecutarlo (PowerShell):
    1. Docker Desktop abierto y el contenedor gis-postgres corriendo
       (verificar con: docker compose ps).
    2. Ir a la carpeta del proyecto:
           cd D:\\Proyectos\\data-automation-geospatial-lab\\13-python-geospatial
    3. Activar el entorno virtual (en cada ventana nueva de PowerShell):
           .venv\\Scripts\\Activate.ps1
       Debe aparecer (.venv) al inicio de la línea.
    4. Ejecutar:
           python scripts\\comunas_centroides.py

Credenciales:
    Se leen del archivo .env en la raíz del repo (POSTGRES_USER,
    POSTGRES_PASSWORD, POSTGRES_DB). Ese archivo está en .gitignore:
    las contraseñas nunca quedan en el código ni en GitHub.
"""

# ---------------------------------------------------------------------
# Librerías
# ---------------------------------------------------------------------
import os                      # os.environ: lee variables de entorno (las del .env)
from pathlib import Path       # Path: maneja rutas de archivos sin importar el sistema operativo

import geopandas as gpd        # GeoDataFrame: tabla con columna de geometría y CRS
import pandas as pd            # pandas: base de geopandas; aquí solo para opciones de impresión
from dotenv import load_dotenv # load_dotenv: carga las variables del archivo .env
from sqlalchemy import create_engine   # create_engine: crea la conexión a la base de datos
from sqlalchemy.engine import URL      # URL: arma la dirección de conexión por partes


# =====================================================================
# Conexión a PostGIS
# =====================================================================

# Path(__file__)  → la ruta de este script
# .resolve()      → la convierte en ruta completa (D:\...\scripts\comunas_centroides.py)
# .parents[2]     → sube 3 niveles: [0] scripts → [1] 13-python-geospatial → [2] raíz del repo
# Así el script encuentra el .env sin importar desde qué carpeta se ejecute.
RAIZ_REPO = Path(__file__).resolve().parents[2]

# Carga POSTGRES_USER, POSTGRES_PASSWORD y POSTGRES_DB del .env como variables de entorno.
load_dotenv(RAIZ_REPO / ".env")

# URL.create arma la dirección de conexión por partes, en vez de escribirla como texto
# ("postgresql+psycopg://usuario:clave@localhost:5432/gisdb"). Ventaja: si la contraseña
# tiene caracteres especiales (@, #, /), no rompe la dirección.
#
# os.environ["NOMBRE"] lee una variable; si no existe, el script falla con un error claro
# (KeyError) en lugar de intentar conectarse con datos vacíos.
url = URL.create(
    drivername="postgresql+psycopg",   # SQLAlchemy hablando con PostgreSQL a través de psycopg 3
    username=os.environ["POSTGRES_USER"],
    password=os.environ["POSTGRES_PASSWORD"],
    host="127.0.0.1",                     # el script corre en la laptop, FUERA de Docker: usa el puerto
                                          # publicado 127.0.0.1:5432, igual que DBeaver.
                                          # Se usa 127.0.0.1 y no "localhost": en Windows, "localhost"
                                          # puede intentar primero IPv6 (::1), donde Docker no publica
                                          # el puerto, y la conexión tardaba más de 2 minutos.
    port=5432,
    database=os.environ["POSTGRES_DB"],
)

# El engine es el "punto de conexión" que geopandas usará para leer y escribir.
# No abre la conexión todavía: se abre cuando se ejecuta la primera consulta.
engine = create_engine(url)


# =====================================================================
# 13.3 Leer las comunas desde PostGIS
# =====================================================================

# read_postgis ejecuta un SELECT y devuelve un GeoDataFrame.
#   - geom_col="geom": columna que contiene la geometría.
#   - El CRS (EPSG:6256) lo toma automáticamente del SRID de la columna geom.
comunas = gpd.read_postgis(
    "SELECT id_comuna, nombre, area_km2, geom FROM monitoreo.comunas ORDER BY id_comuna",
    engine,
    geom_col="geom",
)

# Ancho de la consola para que pandas no parta la tabla en varias líneas.
pd.set_option("display.width", 120)

print("CRS:", comunas.crs)                # debe mostrar EPSG:6256
print("Comunas leídas:", len(comunas))    # debe mostrar 12
# drop(columns="geom") omite la geometría al imprimir: es una lista larguísima de vértices.
print(comunas.drop(columns="geom"))



# =====================================================================
# 13.3 Comparar el área calculada con area_km2 (Proyecto 4)
# =====================================================================

# area_km2 es NUMERIC en PostgreSQL. Python lo recibe como Decimal (número exacto),
# que no se puede mezclar con los float que calcula geopandas. astype(float) lo convierte.
comunas["area_km2"] = comunas["area_km2"].astype(float)

# .area calcula el área de cada polígono en las unidades del CRS.
# EPSG:6256 está en metros → el resultado está en m². Dividido por 1e6 (1.000.000) → km².
# (Si el CRS fuera en grados, como EPSG:4326, el "área" saldría en grados², que no sirve.)
comunas["area_calc_km2"] = comunas.area / 1e6

# Diferencia absoluta y porcentual entre lo calculado en Python y lo calculado en QGIS.
comunas["dif_km2"] = comunas["area_calc_km2"] - comunas["area_km2"]
comunas["dif_pct"] = comunas["dif_km2"] / comunas["area_km2"] * 100


# =====================================================================
# 13.3 Centroides
# =====================================================================

# .centroid devuelve el centro geométrico de cada polígono (un punto de shapely por fila),
# en el mismo CRS de la capa (EPSG:6256).
comunas["centroide"] = comunas.centroid

# ¿El centroide cae dentro de su propia comuna?
# .within compara fila por fila: el centroide de la fila 0 con el polígono de la fila 0, etc.
# En polígonos irregulares (forma de "C" o "L") el centroide puede quedar FUERA.
comunas["centroide_dentro"] = comunas["centroide"].within(comunas.geometry)


# ===== Resultado =====
columnas = ["id_comuna", "nombre", "area_km2", "area_calc_km2", "dif_km2", "dif_pct", "centroide_dentro"]
print()
print("Comparación de áreas y centroides:")
# round(4) redondea a 4 decimales solo para mostrar; los valores internos no cambian.
print(comunas[columnas].round(4).to_string(index=False))   # to_string(index=False): sin la columna 0, 1, 2...
