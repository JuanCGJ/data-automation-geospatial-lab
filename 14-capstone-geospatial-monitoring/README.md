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
1. Definir el escenario del capstone y documentar los datos, su uso y sus fuentes (`docs/escenario-y-fuentes.md`).
2. Diseñar el diagrama de arquitectura completo del sistema: fuentes → n8n / Python → PostGIS → QGIS.
3. Calcular la susceptibilidad de cada comuna con estadística zonal sobre el raster del SGC en QGIS, y compararla con las comunas que la literatura señala como más susceptibles.
4. Crear el esquema `plataforma` y su modelo de datos en PostGIS, y cargar la susceptibilidad y el umbral de cada comuna.
5. Construir el workflow de n8n que consulta la lluvia de los últimos 25 días (A25) en el punto interior de cada comuna, la guarda y registra una alerta cuando supera el umbral.
6. Escribir en Python un simulador que genere recorridos de brigadas de emergencia y envíe cada posición al webhook de n8n.
7. Construir el workflow de n8n que recibe las posiciones de las brigadas, identifica su comuna con PostGIS y las guarda.
8. Detectar las comunas en alerta sin cobertura (ninguna brigada a menos de X km, `ST_DWithin`) y registrarlas como alerta.
9. Armar en QGIS el mapa de monitoreo: comunas por susceptibilidad y estado de alerta, brigadas y comunas sin cobertura.
10. Escribir en Python un reporte automático con el resumen de alertas por comuna.
11. Reproducir un periodo histórico real de lluvias y grabar un video corto (1-2 min) del sistema funcionando de principio a fin.
12. Recopilar en `docs/interview-questions.md` 2-3 preguntas de entrevista por proyecto, con respuestas ya practicadas.

## Progreso (checklist)
- [ ] **14.1** — Definir el escenario del capstone y documentar los datos, su uso y sus fuentes. Evidencia: pendiente
- [ ] **14.2** — Diseñar el diagrama de arquitectura completo del sistema. Evidencia: pendiente
- [ ] **14.3** — Calcular la susceptibilidad de cada comuna con estadística zonal sobre el raster del SGC y compararla con la literatura. Evidencia: pendiente
- [ ] **14.4** — Crear el esquema `plataforma` y su modelo de datos, y cargar la susceptibilidad y el umbral de cada comuna. Evidencia: pendiente
- [ ] **14.5** — Workflow de n8n de lluvia A25 por comuna con alerta por umbral. Evidencia: pendiente
- [ ] **14.6** — Simulador en Python de recorridos de brigadas que envía posiciones al webhook. Evidencia: pendiente
- [ ] **14.7** — Workflow de n8n que recibe posiciones de brigadas, identifica su comuna y las guarda. Evidencia: pendiente
- [ ] **14.8** — Detectar y registrar las comunas en alerta sin cobertura (`ST_DWithin`). Evidencia: pendiente
- [ ] **14.9** — Mapa de monitoreo en QGIS. Evidencia: pendiente
- [ ] **14.10** — Reporte automático en Python con el resumen de alertas por comuna. Evidencia: pendiente
- [ ] **14.11** — Reproducir un periodo histórico de lluvias y grabar el video del sistema funcionando. Evidencia: pendiente
- [ ] **14.12** — Recopilar en `docs/interview-questions.md` 2-3 preguntas de entrevista por proyecto, con respuestas practicadas. Evidencia: pendiente

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
