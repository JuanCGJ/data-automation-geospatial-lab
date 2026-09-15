# Proyecto 14 — Capstone: Plataforma de Monitoreo y Automatización de Activos Geoespaciales

> Estado: pendiente

## Objetivo
Integrar todo lo aprendido en un proyecto final: una plataforma de monitoreo y automatización de activos geoespaciales.

## Requisitos
Todos los proyectos anteriores (0-13) completados y funcionando.

## Entregable
Repo completo + video corto (1-2 min) mostrando el flujo funcionando de principio a fin.

## Conceptos
**Arquitectura de un pipeline geoespacial de punta a punta:** una fuente de datos (API o CSV) alimenta un proceso de automatización (n8n), que guarda y valida los datos en una base de datos espacial (PostgreSQL/PostGIS), la cual finalmente se visualiza y analiza en un cliente GIS (QGIS).

**Integración de las piezas del stack:** este proyecto no introduce herramientas nuevas — consiste en conectar entre sí lo construido en los proyectos 0 a 13 en un solo flujo coherente.

## Ejercicios
1. Diseñar el diagrama de arquitectura completo del flujo: API/CSV → n8n → PostgreSQL/PostGIS → QGIS.
2. Implementar el flujo integrando los workflows, tablas y capas construidos en los proyectos anteriores.
3. Grabar un video corto (1-2 min) mostrando el flujo funcionando de principio a fin.
4. Recopilar en `docs/interview-questions.md` 2-3 preguntas de entrevista por proyecto, con respuestas ya practicadas.

## Progreso (checklist)
- [ ] **14.1** — Diseñar el diagrama de arquitectura completo del flujo: API/CSV → n8n → PostgreSQL/PostGIS → QGIS. Evidencia: pendiente
- [ ] **14.2** — Implementar el flujo integrando los workflows, tablas y capas construidos en los proyectos anteriores. Evidencia: pendiente
- [ ] **14.3** — Grabar un video corto (1-2 min) mostrando el flujo funcionando de principio a fin. Evidencia: pendiente
- [ ] **14.4** — Recopilar en `docs/interview-questions.md` 2-3 preguntas de entrevista por proyecto, con respuestas ya practicadas. Evidencia: pendiente

## Qué aprendí

## Problemas encontrados y solución

## Preguntas de entrevista
- **¿Cómo explicarías este proyecto de principio a fin en una entrevista?** Describiendo el flujo de datos (fuente → automatización → almacenamiento espacial → visualización), la razón detrás de cada elección de stack, y un ejemplo concreto de lo que resuelve.
- **¿Qué parte del stack cambiarías o mejorarías si tuvieras más tiempo, y por qué?** (Respuesta personal — pensarla en base a las limitaciones reales que encontraste durante el desarrollo, ej. escalabilidad de n8n, manejo de errores, o pasar de QGIS a un dashboard web.)

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
