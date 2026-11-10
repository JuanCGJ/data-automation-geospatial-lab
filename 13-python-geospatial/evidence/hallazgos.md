# Proyecto 13 — Hallazgos

## 13.1 — Librerías: geopandas, shapely y psycopg

```
PostGIS (Docker) ──psycopg──► Python ──geopandas──► GeoDataFrame
                  (conexión)            (la tabla)        │
                                                          └─ cada geometría es un objeto de shapely
                                                             (calcula área, centroide, contiene...)
```

| Librería | Qué es | Para qué sirve en este proyecto |
|---|---|---|
| **psycopg** | Driver de PostgreSQL para Python (versión 3) | Abrir la conexión a `gisdb` y ejecutar SQL desde un script |
| **SQLAlchemy** | Capa que estandariza conexiones a bases de datos | GeoPandas la usa para `read_postgis` y `to_postgis`; por dentro usa psycopg |
| **shapely** | Representa y opera geometrías individuales; usa GEOS, el mismo motor de PostGIS y QGIS | Calcular área, centroide y relaciones espaciales de cada comuna |
| **geopandas** | Extiende pandas: un GeoDataFrame es una tabla con columna de geometría y CRS | Leer `monitoreo.comunas`, calcular sobre todas las filas a la vez y escribir el resultado en PostGIS |

```python
# shapely: una sola geometría
from shapely.geometry import Point
p = Point(-75.5174, 5.0685)          # (lon, lat), igual que ST_MakePoint

# geopandas: la tabla completa, leída desde PostGIS
comunas = gpd.read_postgis("SELECT * FROM monitoreo.comunas", conexion, geom_col="geom")
comunas.geometry.iloc[0]             # ← un objeto de shapely (un polígono)
comunas.centroid                     # shapely calcula el centroide de cada fila
```

### Equivalencias
| QGIS / PostGIS | Python |
|---|---|
| Tabla de atributos | GeoDataFrame |
| `ST_Area`, `ST_Centroid` | `.area`, `.centroid` |
| `ST_Transform` | `.to_crs()` |
| `ST_Contains` / unión espacial | `gpd.sjoin(..., predicate="within")` |
| Conexión de DBeaver | `create_engine("postgresql+psycopg://...")` |

### Cuándo QGIS y cuándo Python
- QGIS: ver, explorar, verificar y hacer mapas; tareas de una sola vez.
- Python: procesos repetibles, automatizados o sobre muchos datos, documentados en el repo.

### Centroide
El **centroide** es el centro geométrico de un polígono (su punto de equilibrio). Sirve para representar una zona con un punto (etiquetas, marcadores, distancias entre zonas). En polígonos irregulares (forma de "C" o "L") puede caer **fuera** del polígono; cuando se necesita un punto que siempre quede dentro se usa `representative_point()` (GeoPandas) o `ST_PointOnSurface` (PostGIS).
