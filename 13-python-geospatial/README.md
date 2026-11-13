# Proyecto 13 — Python + datos geoespaciales

> Estado: completado

## Objetivo
Aprender a manipular datos geoespaciales con Python y conectarlos a PostgreSQL/PostGIS.

## Requisitos
Python instalado con geopandas, shapely y psycopg; contenedor de PostgreSQL+PostGIS corriendo.

## Entregable
Script de Python que lea una capa, calcule área/centroides y escriba los resultados a PostgreSQL/PostGIS.

## Conceptos
**Geopandas:** extiende pandas para trabajar con datos geoespaciales; un `GeoDataFrame` es como un DataFrame normal pero con una columna de geometría y operaciones espaciales nativas.

**Shapely:** librería que representa y opera geometrías (puntos, líneas, polígonos) en Python, usada internamente por geopandas.

**Psycopg:** driver que permite a Python conectarse y ejecutar comandos SQL directamente contra PostgreSQL.

## Ejercicios
1. Consultar y escribir qué son y para qué sirven las librerías geopandas, shapely y psycopg.
2. Instalar las librerías necesarias en un entorno virtual de Python.
3. Escribir un script que lea la capa de comunas desde PostGIS (cargada en 9.5) con geopandas, calcule el centroide de cada comuna y compare su área con el campo `area_km2` del ejercicio 4.2.
4. Escribir los centroides en una tabla nueva de PostGIS.

## Progreso (checklist)
- [x] **13.1** — Consultar y escribir qué son y para qué sirven las librerías geopandas, shapely y psycopg. Evidencia: [hallazgos](evidence/hallazgos.md)
- [x] **13.2** — Instalar las librerías necesarias en un entorno virtual de Python. Evidencia: [requirements.txt](requirements.txt), [hallazgos](evidence/hallazgos.md)
- [x] **13.3** — Escribir un script que lea la capa de comunas desde PostGIS (cargada en 9.5) con geopandas, calcule el centroide de cada comuna y compare su área con el campo `area_km2` del ejercicio 4.2. Evidencia: [script](scripts/comunas_centroides.py), [hallazgos](evidence/hallazgos.md)
- [x] **13.4** — Escribir los centroides en una tabla nueva de PostGIS. Evidencia: [script](scripts/comunas_centroides.py), [verificación SQL](sql/verificacion.sql), [proyecto QGIS](proyecto-13.qgz), [hallazgos](evidence/hallazgos.md)

## Qué aprendí
- Qué hace cada librería del stack geoespacial de Python: psycopg (driver), SQLAlchemy (conexión), shapely (geometrías, con GEOS) y geopandas (tablas con geometría y CRS); y GeoAlchemy2 para escribir geometrías en PostGIS.
- A instalar Python eligiendo la versión según el soporte de las librerías (3.14 y no la 3.15 recién publicada), a crear y activar un entorno virtual y a congelar sus versiones en `requirements.txt`.
- A mantener en D todo lo que crece (`.venv` dentro del proyecto, caché de pip en `D:\AppsData\pip-cache`) y a permitir los scripts de PowerShell con `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`.
- A configurar VS Code para Python: extensión de Microsoft, *Workspace Trust* e intérprete del `.venv`.
- A leer una tabla de PostGIS con `read_postgis` y credenciales desde `.env`, sin contraseñas en el código.
- Que `.area` en un CRS métrico da m², que el área plana de GeoPandas difiere ~0,07 % del `$area` de QGIS por una diferencia de método, y que el centroide puede caer fuera de un polígono irregular (`representative_point()` siempre cae dentro).
- A escribir un GeoDataFrame en PostGIS con `to_postgis` y a agregar una llave primaria compuesta con SQL desde Python.
- A diagnosticar una demora midiendo por partes (`Measure-Command`): la causa no era el antivirus sino `localhost` resolviendo primero a IPv6.

## Problemas encontrados y solución
**13.2 — `Activate.ps1 cannot be loaded because running scripts is disabled on this system`.** Windows bloquea los scripts de PowerShell por defecto. Solución: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`.

**13.3 — La extensión de Python no funcionaba en VS Code.** La carpeta estaba en *Restricted Mode* (Workspace Trust). Solución: marcar la carpeta del repo como confiable.

**13.3 — El script tardaba 134 segundos.** `localhost` se resolvía primero a IPv6 (`::1`), pero Docker publica PostgreSQL solo en `127.0.0.1`; la conexión esperaba en la dirección equivocada antes de probar la correcta. Solución: `host="127.0.0.1"` → 3,8 s.

**13.4 — `to_postgis` necesitaba GeoAlchemy2.** Solución: instalarla y regenerar `requirements.txt`.

## Preguntas de entrevista
- **¿Qué es un GeoDataFrame y en qué se diferencia de un DataFrame normal de pandas?** Es un DataFrame con una columna de geometría y operaciones espaciales nativas (área, distancia, intersección), mientras que un DataFrame normal solo maneja datos tabulares sin noción de ubicación.
- **¿Por qué conectarías Python directamente a PostgreSQL en vez de exportar/importar archivos manualmente?** Porque automatiza el flujo de punta a punta (leer, procesar, guardar) sin pasos manuales intermedios, reduciendo errores y permitiendo integrarlo en un pipeline más grande.
- **¿Por qué usas un entorno virtual y un `requirements.txt`?** Para que cada proyecto tenga sus propias librerías y versiones sin chocar con otros, y para que cualquiera recree exactamente el mismo entorno con `pip install -r requirements.txt`. El `.venv` no se versiona; la receta sí.
- **¿Cómo manejas las credenciales de la base de datos en un script?** En un archivo `.env` fuera del repo (en `.gitignore`), leído con `python-dotenv`; el código solo usa `os.environ[...]`. Así el script se puede subir a GitHub sin exponer contraseñas.
- **¿Qué diferencia hay entre el centroide y `representative_point()`?** El centroide es el centro geométrico y en polígonos irregulares puede caer fuera; `representative_point()` (como `ST_PointOnSurface`) garantiza un punto dentro. En este proyecto 2 de 12 comunas tenían el centroide fuera, y lo verifiqué con `.within()`, en DBeaver y en QGIS.
- **Un script tardaba más de 2 minutos en conectarse a PostgreSQL. ¿Cómo lo diagnosticaste?** Midiendo por partes: el `import` tardaba 3 s, así que el problema era la conexión. `localhost` resolvía primero a IPv6 y Docker publicaba el puerto solo en IPv4; con `127.0.0.1` bajó a 3,8 s.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
- `hallazgos.md`: hallazgos de los ejercicios.
- `13.2-pip-install.png`, `13.2-verificacion-librerias.png`, `13.2-requirements.png`: instalación, verificación de versiones y `requirements.txt`.
- `13.3-lectura-postgis.png`, `13.3-areas-centroides.png`: lectura de las comunas desde PostGIS y comparación de áreas y centroides.
- `13.4-escritura-postgis.png`, `13.4-dbeaver-verificacion.png`, `13.4-qgis-centroides.png`: tabla escrita desde Python, verificación en DBeaver y centroides en QGIS.
- `scripts/comunas_centroides.py`, `sql/verificacion.sql`, `requirements.txt`, `proyecto-13.qgz`: script, consultas de verificación, librerías del entorno y proyecto de QGIS (fuera de `evidence/`).
