# Proyecto 14 — Capstone: Sistema de alerta temprana por deslizamientos en Manizales

> Estado: en progreso

*Plataforma de monitoreo y automatización de activos geoespaciales.*

## Objetivo
Integrar todo lo aprendido en un proyecto final: un sistema que, a partir de la lluvia acumulada y de la susceptibilidad del terreno de cada comuna, genera alertas de deslizamiento y verifica si las brigadas de emergencia cubren las comunas en alerta.

## Requisitos
- Proyectos 0 a 13 completados: Docker con PostgreSQL/PostGIS y n8n, QGIS, DBeaver y el entorno virtual de Python del Proyecto 13.
- Tablas de lectura: `monitoreo.comunas` (Proyecto 9) y `monitoreo.comunas_centroides` (Proyecto 13).
- Mapa Nacional de Susceptibilidad por Movimientos en Masa del SGC (`SuscMM_100k.tif`), guardado fuera del repo.

**Decisión de diseño:** el capstone usa un **esquema nuevo** en `gisdb` (`plataforma`) con tablas y workflows propios. Las tablas de los proyectos anteriores no se modifican; `monitoreo.comunas` y `monitoreo.comunas_centroides` se usan solo como lectura. Así los proyectos 8-13 siguen coincidiendo con su documentación, y el capstone se puede recrear o borrar de una vez sin afectar nada más.

**Escenario, datos y fuentes:** [`docs/escenario-y-fuentes.md`](docs/escenario-y-fuentes.md).

**Arquitectura:** [`docs/arquitectura.md`](docs/arquitectura.md).

**Tablas de la base de datos:** [`docs/tablas.md`](docs/tablas.md).

## Entregable
Repo completo + diagrama de arquitectura + video corto (1-2 min) mostrando el flujo funcionando de principio a fin.

## Conceptos
**Arquitectura de un pipeline geoespacial de punta a punta:** fuentes de datos (API, raster y un simulador) alimentan procesos de automatización (n8n y Python), que guardan y analizan los datos en una base espacial (PostGIS), la cual se visualiza en un cliente GIS (QGIS).

**Riesgo = detonante × condición del terreno:** la lluvia acumulada (indicador **A25**: lluvia de los últimos 25 días, umbral oficial de 200 mm en Manizales) es el detonante; la susceptibilidad del terreno define cuánta lluvia aguanta cada comuna. El umbral es inverso a la susceptibilidad: más frágil → menos lluvia para alertar.

**Raster y estadística zonal:** un raster es una cuadrícula de celdas con valores (aquí, clases de susceptibilidad). La estadística zonal resume las celdas que caen dentro de cada polígono (por ejemplo, la clase predominante por comuna) y convierte un dato raster en un atributo vectorial.

**Simulación de la fuente de datos:** para probar un pipeline sin dispositivos reales, un script genera datos realistas (posiciones de brigadas) y los envía igual que lo haría la fuente real.

**Enriquecimiento de datos:** combinar datos propios (comunas, brigadas) con una fuente externa (lluvia de Open-Meteo) para tomar decisiones que ninguna de las dos permite por separado.

**Análisis de cobertura:** determinar si un recurso (brigada) está a una distancia aceptable de una zona que lo necesita (`ST_DWithin`).

## Ejercicios
1. Definir el escenario del sistema de alerta: documentar el problema, los datos que se usarán, la regla de alerta y sus fuentes en `docs/escenario-y-fuentes.md`.
2. Diseñar el diagrama de arquitectura que muestre las fuentes de datos (Open-Meteo, raster del SGC y simulador de brigadas), los procesos (n8n y Python), la base de datos (PostGIS) y la visualización (QGIS), y cómo fluyen los datos entre ellos.
3. Calcular la susceptibilidad de cada comuna: recortar el raster del SGC a Manizales, aplicar estadística zonal en QGIS para obtener la clase predominante por comuna y compararla con las comunas que señala la literatura.
4. Crear el esquema `plataforma` en PostGIS con sus tablas (susceptibilidad y umbral por comuna, brigadas, posiciones, lluvia y alertas) y cargar la susceptibilidad calculada en el 14.3.
5. Construir el workflow de lluvia en n8n: consultar en Open-Meteo la lluvia diaria de los últimos 25 días en el punto interior de cada comuna, calcular el A25, guardarlo y registrar una alerta cuando supere el umbral de la comuna.
6. Programar en Python un simulador de brigadas: generar recorridos por la ciudad y enviar cada posición al webhook de n8n, como lo haría un GPS real.
7. Construir el workflow de posiciones en n8n: recibir cada posición por webhook, identificar con `ST_Contains` en qué comuna está la brigada y guardarla.
8. Detectar las comunas en alerta sin cobertura: identificar con `ST_DWithin` las comunas en alerta que no tienen ninguna brigada a menos de X km y registrarlas como alerta de cobertura.
9. Diseñar el mapa de monitoreo en QGIS: comunas por susceptibilidad y estado de alerta, posiciones de las brigadas y comunas sin cobertura.
10. Programar en Python un reporte automático que resuma por comuna la lluvia A25, las alertas generadas y la cobertura de brigadas.
11. Reproducir un periodo histórico real de lluvias con los datos de Open-Meteo y grabar un video corto (1-2 min) del sistema funcionando de principio a fin.
12. Consolidar en `docs/interview-questions.md` 2-3 preguntas clave por proyecto, con sus respuestas.

## Progreso (checklist)
- [x] **14.1** — Definir el escenario del sistema de alerta: documentar el problema, los datos que se usarán, la regla de alerta y sus fuentes en `docs/escenario-y-fuentes.md`. Evidencia: [escenario y fuentes](docs/escenario-y-fuentes.md)
- [x] **14.2** — Diseñar el diagrama de arquitectura que muestre las fuentes de datos (Open-Meteo, raster del SGC y simulador de brigadas), los procesos (n8n y Python), la base de datos (PostGIS) y la visualización (QGIS), y cómo fluyen los datos entre ellos. Evidencia: [arquitectura](docs/arquitectura.md), [hallazgos](evidence/hallazgos.md)
- [x] **14.3** — Calcular la susceptibilidad de cada comuna: recortar el raster del SGC a Manizales, aplicar estadística zonal en QGIS para obtener la clase predominante por comuna y compararla con las comunas que señala la literatura. Evidencia: [GeoPackage final](data/comunas_susceptibilidad_hist.gpkg), [hallazgos](evidence/hallazgos.md)
- [x] **14.4** — Crear el esquema `plataforma` en PostGIS con sus tablas (susceptibilidad y umbral por comuna, brigadas, posiciones, lluvia y alertas) y cargar la susceptibilidad calculada en el 14.3. Evidencia: [script](sql/plataforma.sql), [hallazgos](evidence/hallazgos.md)
- [ ] **14.5** — Construir el workflow de lluvia en n8n: consultar en Open-Meteo la lluvia diaria de los últimos 25 días en el punto interior de cada comuna, calcular el A25, guardarlo y registrar una alerta cuando supere el umbral de la comuna. Evidencia: pendiente
- [ ] **14.6** — Programar en Python un simulador de brigadas: generar recorridos por la ciudad y enviar cada posición al webhook de n8n, como lo haría un GPS real. Evidencia: pendiente
- [ ] **14.7** — Construir el workflow de posiciones en n8n: recibir cada posición por webhook, identificar con `ST_Contains` en qué comuna está la brigada y guardarla. Evidencia: pendiente
- [ ] **14.8** — Detectar las comunas en alerta sin cobertura: identificar con `ST_DWithin` las comunas en alerta que no tienen ninguna brigada a menos de X km y registrarlas como alerta de cobertura. Evidencia: pendiente
- [ ] **14.9** — Diseñar el mapa de monitoreo en QGIS: comunas por susceptibilidad y estado de alerta, posiciones de las brigadas y comunas sin cobertura. Evidencia: pendiente
- [ ] **14.10** — Programar en Python un reporte automático que resuma por comuna la lluvia A25, las alertas generadas y la cobertura de brigadas. Evidencia: pendiente
- [ ] **14.11** — Reproducir un periodo histórico real de lluvias con los datos de Open-Meteo y grabar un video corto (1-2 min) del sistema funcionando de principio a fin. Evidencia: pendiente
- [ ] **14.12** — Consolidar en `docs/interview-questions.md` 2-3 preguntas clave por proyecto, con sus respuestas. Evidencia: pendiente

## Qué aprendí
*Ejercicios 14.1 a 14.4; se completa al cerrar el proyecto.*

- A definir un escenario con fuentes verificables antes de construir: el indicador oficial A25 de Manizales (200 mm en 25 días), las comunas con evidencia publicada y qué datos son supuestos del proyecto.
- A diferenciar **susceptibilidad** (condición del terreno) de **amenaza** (que ya incluye detonantes como la lluvia), y por qué el umbral de lluvia es inverso a la susceptibilidad.
- A diseñar y documentar una arquitectura por capas (fuentes, procesamiento, almacenamiento, salidas) con un diagrama en Mermaid versionado como texto.
- A organizar datos pesados: los crudos en `data/raw/` ignorados por Git (límite de 100 MB de GitHub) y solo los procesados en el repo.
- A leer la ficha técnica de un raster antes de usarlo: tamaño de celda, CRS y rango de valores, y a descubrir que sus valores eran **códigos** que una tabla de valores (`.vat.dbf`) traduce a clases.
- A recortar y reproyectar un raster en un solo paso, con remuestreo por **vecino más cercano** para datos categóricos, y a verificar el resultado (el área con datos coincidió con la suma de las comunas).
- A reclasificar un raster con una tabla (*Reclassify by layer*) y a simbolizar un raster categórico (*Paletted/Unique values*).
- A convertir un raster en un atributo por polígono con **estadística zonal** e **histograma zonal**, y que en datos categóricos se usa la mayoría y no el promedio, aunque la mayoría puede esconder la variación interna.
- A construir un criterio de nivel defendible: dato oficial (% del área en alta + muy alta) más un ajuste conservador por evidencia local, separado en columnas para que se vea qué viene de cada fuente.
- A asignar el CRS del proyecto de QGIS: el primer raster cargado tenía un CRS sin código EPSG y el proyecto quedó como *Unknown CRS*; se fijó en EPSG:6256.
- A diseñar un modelo de datos antes de escribir SQL: tablas, llaves primarias y foráneas, normalización (y cuándo romperla a propósito para conservar historial).
- A proteger la calidad del dato desde la base de datos con `CHECK`, `UNIQUE` y llaves foráneas, y a escribir scripts re-ejecutables con `IF NOT EXISTS`, `ON CONFLICT DO NOTHING` y *upsert* (`ON CONFLICT DO UPDATE`).
- La diferencia entre el índice de la llave primaria (B-tree, búsqueda por valor) y un índice espacial GiST (búsqueda por ubicación).
- A cargar datos uniendo atributos de un archivo con geometrías que ya están en la base, evitando un problema de CRS en lugar de pelear con él.

## Problemas encontrados y solución
**14.1 — No se pudo buscar la capa de amenaza de la Alcaldía.** El directorio de servicios ArcGIS REST respondió `403: The administrator has disabled the Services Directory`. Solución: usar el Mapa Nacional de Susceptibilidad del SGC, oficial y descargable.

**14.4 — `SRID must be <= 998999` al importar el GeoPackage del 14.3 con DB Manager.** El GeoPackage guarda el SRID 6256 sin definición y QGIS lo trata como un CRS personalizado con un número interno que PostGIS no acepta. Solución: tomar la geometría de `monitoreo.comunas`, ya en PostGIS, y cargar solo los atributos con un `INSERT ... SELECT` en el script.

## Preguntas de entrevista
- **¿Cómo explicarías este proyecto de principio a fin en una entrevista?**
- **¿Por qué el umbral de lluvia depende de la susceptibilidad de cada comuna?**
- **¿Cómo convertiste un mapa raster nacional en un atributo por comuna?**
- **¿Por qué simulaste las brigadas y cómo conectarías una fuente real?**
- **¿Qué parte del stack cambiarías o mejorarías si tuvieras más tiempo, y por qué?** (Respuesta personal — pensarla en base a las limitaciones reales que encontraste durante el desarrollo.)

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
- `14.2-arquitectura.png`: diagrama de arquitectura del sistema.
- `hallazgos.md`: hallazgos de los ejercicios, con sus capturas.
- `14.3-raster-colombia.png`, `14.3-raster-comunas.png`, `14.3-raster-crs-pixel.png`, `14.3-raster-banda.png`, `14.3-tabla-valores.png`: raster del SGC, su ficha técnica y su tabla de valores.
- `14.3-raster-recortado.png`, `14.3-recorte-informacion.png`, `14.3-recorte-crs.png`, `14.3-recorte-bandas.png`: raster recortado y reproyectado, y su verificación.
- `14.3-reclasificacion-log.png`, `14.3-reclasificado-bandas.png`, `14.3-susceptibilidad-clases.png`: reclasificación código → clase y raster por clases.
- `14.3-estadistica-zonal.png`, `14.3-histograma-zonal.png`, `14.3-nivel-por-comuna.png`, `14.3-mapa-nivel.png`: estadística e histograma zonal, nivel final y mapa por comuna.
- `14.4-esquema-plataforma.png`, `14.4-tablas-plataforma.png`, `14.4-umbrales.png`, `14.4-brigadas.png`, `14.4-comunas-riesgo.png`, `14.4-qgis-comunas-riesgo.png`: esquema y tablas del modelo de datos, datos cargados y verificación en QGIS.
