# Proyecto 0 — Entorno de desarrollo

> Estado: completado ✅

## Objetivo
Dejar listo el entorno de trabajo: Git, GitHub, VS Code, Docker Desktop, y el repo clonado localmente con PostgreSQL/PostGIS y n8n corriendo en contenedores.

## Requisitos
Git, Docker Desktop, VS Code, cuenta de GitHub.

## Entregable
Captura de `docker ps` con ambos contenedores corriendo + este README actualizado.

## Conceptos
**Control de versiones (Git):** sistema que guarda el historial de cambios de un proyecto como una serie de "fotos" (commits). Permite volver atrás, comparar versiones y trabajar sin miedo a romper algo, porque todo cambio queda registrado y es reversible.

**GitHub:** el repo remoto donde vive ese historial en la nube. Aquí cumple dos funciones: (1) **showcase/documentación** — cada carpeta con su README y evidencia sirve como portafolio visible para quien revise el proyecto; (2) **trabajo en equipo** — aunque hoy es un proyecto individual, GitHub está pensado para colaborar vía ramas (branches), pull requests e issues, así que documentar bien desde ahora deja el hábito listo para ese escenario.

**Terminal básica:** la forma de dar instrucciones al sistema operativo por texto en vez de clics (navegar carpetas, ejecutar git, levantar contenedores). Es la interfaz común entre Git, Docker y casi cualquier herramienta de este stack.

**Docker (y por qué se usa aquí):** empaqueta una aplicación con todo lo que necesita para correr (PostgreSQL, PostGIS, n8n) en un "contenedor" aislado, sin instalarla directamente en el sistema operativo. Se usa en este curso porque: es reproducible (un `docker-compose.yml` en el repo permite que cualquiera levante el mismo entorno), no ensucia la laptop con instalaciones nativas, y no depende de trials en la nube con fecha de vencimiento.

**VS Code:** editor de código donde se escriben y organizan todos los archivos del proyecto (Markdown, SQL, Python, docker-compose.yml, etc.). Se usa aquí porque integra terminal, control de versiones (Git) y extensiones (Docker, SQL, Python) en un mismo lugar, evitando saltar entre programas distintos.

## Ejercicios
1. **0.1** — Repasar la teoría: control de versiones (git/github), terminal básica, variables de entorno, `.gitignore`, y qué es Docker y por qué se usa.
2. **0.2** — Instalar Docker Desktop.
3. **0.3** — Instalar Git, crear cuenta de GitHub e instalar VS Code.
4. **0.4** — Crear el repo `data-automation-geospatial-lab` con la estructura de carpetas completa.
5. **0.5** — Levantar PostgreSQL+PostGIS y n8n con un `docker-compose.yml`.
6. **0.6** — Conectar a PostgreSQL desde DBeaver/pgAdmin.

## Progreso (checklist)
- [x] **0.1** — Teoría de git/github/Docker explicada. Evidencia: n/a (conceptual)
- [x] **0.2** — Git instalado (`git version 2.55.0`). Evidencia: `evidence/0.2-git-instalado.png`
- [x] **0.3** — Docker Desktop instalado (`Docker version 29.7.2`). Evidencia: `evidence/0.3-docker-desktop-instalado.png`
- [x] **0.4** — Repo clonado en `D:\Proyectos\data-automation-geospatial-lab` con estructura completa. Evidencia: `evidence/0.4-clone-y-estructura.png`
- [x] **0.5** — PostgreSQL+PostGIS y n8n levantados con docker-compose. Evidencia: `evidence/0.5-docker-ps-contenedores.png`, `evidence/0.5-n8n-interfaz.png`
- [x] **0.6** — Conexión a PostgreSQL desde DBeaver confirmada (PostgreSQL 16.4). Evidencia: `evidence/0.6-dbeaver-conectado.png`

## Qué aprendí
- A instalar y configurar Git, Docker Desktop y DBeaver desde cero en Windows.
- Que Docker permite correr PostgreSQL/PostGIS y n8n en contenedores aislados, sin instalarlos directamente en el sistema operativo.
- A levantar un stack completo (base de datos + automatización) con un solo `docker-compose.yml`, y a verificar que los contenedores están corriendo con `docker ps`.
- A conectar una herramienta externa (DBeaver) a una base de datos que vive dentro de un contenedor.
- A documentar el trabajo desde el inicio (README + evidencia) en vez de dejarlo para el final.

## Problemas encontrados y solución

## Preguntas de entrevista
- **¿Por qué usar Docker para este stack?** Porque permite tener PostgreSQL/PostGIS y n8n corriendo de forma reproducible y aislada, sin instalarlos nativamente en el sistema operativo. Cualquiera puede clonar el repo, correr `docker-compose up` y tener el mismo entorno, sin depender de versiones instaladas manualmente ni de trials en la nube con fecha de vencimiento.
- **¿Diferencia entre PostgreSQL y PostGIS?** PostgreSQL es el motor de base de datos relacional (tablas, SQL, transacciones). PostGIS es una extensión que se instala sobre PostgreSQL para agregar tipos de datos y funciones espaciales (geometry/geography, `ST_Distance`, `ST_Contains`, etc.), permitiendo guardar y consultar información geográfica directamente en la base de datos.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
