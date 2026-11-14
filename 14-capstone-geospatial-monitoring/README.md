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
- [ ] **14.3** — Calcular la susceptibilidad de cada comuna: recortar el raster del SGC a Manizales, aplicar estadística zonal en QGIS para obtener la clase predominante por comuna y compararla con las comunas que señala la literatura. Evidencia: pendiente
- [ ] **14.4** — Crear el esquema `plataforma` en PostGIS con sus tablas (susceptibilidad y umbral por comuna, brigadas, posiciones, lluvia y alertas) y cargar la susceptibilidad calculada en el 14.3. Evidencia: pendiente
- [ ] **14.5** — Construir el workflow de lluvia en n8n: consultar en Open-Meteo la lluvia diaria de los últimos 25 días en el punto interior de cada comuna, calcular el A25, guardarlo y registrar una alerta cuando supere el umbral de la comuna. Evidencia: pendiente
- [ ] **14.6** — Programar en Python un simulador de brigadas: generar recorridos por la ciudad y enviar cada posición al webhook de n8n, como lo haría un GPS real. Evidencia: pendiente
- [ ] **14.7** — Construir el workflow de posiciones en n8n: recibir cada posición por webhook, identificar con `ST_Contains` en qué comuna está la brigada y guardarla. Evidencia: pendiente
- [ ] **14.8** — Detectar las comunas en alerta sin cobertura: identificar con `ST_DWithin` las comunas en alerta que no tienen ninguna brigada a menos de X km y registrarlas como alerta de cobertura. Evidencia: pendiente
- [ ] **14.9** — Diseñar el mapa de monitoreo en QGIS: comunas por susceptibilidad y estado de alerta, posiciones de las brigadas y comunas sin cobertura. Evidencia: pendiente
- [ ] **14.10** — Programar en Python un reporte automático que resuma por comuna la lluvia A25, las alertas generadas y la cobertura de brigadas. Evidencia: pendiente
- [ ] **14.11** — Reproducir un periodo histórico real de lluvias con los datos de Open-Meteo y grabar un video corto (1-2 min) del sistema funcionando de principio a fin. Evidencia: pendiente
- [ ] **14.12** — Consolidar en `docs/interview-questions.md` 2-3 preguntas clave por proyecto, con sus respuestas. Evidencia: pendiente

## Qué aprendí

## Problemas encontrados y solución

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
