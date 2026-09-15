# Proyecto 8 — PostgreSQL desde cero

> Estado: pendiente

## Objetivo
Aprender los fundamentos de bases de datos relacionales y SQL básico usando PostgreSQL.

## Requisitos
Contenedor de PostgreSQL corriendo (del Proyecto 0); DBeaver o pgAdmin conectado.

## Entregable
Script `.sql` con la creación de tablas, las queries, y capturas de los resultados.

## Conceptos
**Base de datos:** conjunto organizado de datos almacenados electrónicamente.

**Esquema:** agrupación lógica de tablas dentro de una base de datos (ej. `public`).

**Tabla:** estructura de filas y columnas donde se guardan los datos.

**Llave primaria (PK):** columna que identifica de forma única cada fila de una tabla.

**Llave foránea (FK):** columna que referencia la PK de otra tabla, estableciendo una relación entre ambas.

**Índice:** estructura que acelera las búsquedas sobre una columna, a costa de espacio adicional.

**SQL básico:** `SELECT` (consultar), `INSERT` (insertar), `WHERE` (filtrar), `JOIN` (combinar tablas), `GROUP BY` (agregar).

## Ejercicios
1. Consultar y escribir qué son: base de datos, esquema, tabla, llave primaria (PK), llave foránea (FK) e índice.
2. Crear una base de datos nueva con 2 tablas relacionadas por FK (ej. dispositivos y lecturas).
3. Insertar datos de prueba en ambas tablas.
4. Escribir 5 queries que incluyan al menos un JOIN, una agregación y un filtro.
5. Guardar todo en un script `.sql` y tomar capturas de los resultados de cada query.

## Progreso (checklist)
- [ ] **8.1** — Consultar y escribir qué son: base de datos, esquema, tabla, llave primaria (PK), llave foránea (FK) e índice. Evidencia: pendiente
- [ ] **8.2** — Crear una base de datos nueva con 2 tablas relacionadas por FK (ej. dispositivos y lecturas). Evidencia: pendiente
- [ ] **8.3** — Insertar datos de prueba en ambas tablas. Evidencia: pendiente
- [ ] **8.4** — Escribir 5 queries que incluyan al menos un JOIN, una agregación y un filtro. Evidencia: pendiente
- [ ] **8.5** — Guardar todo en un script `.sql` y tomar capturas de los resultados de cada query. Evidencia: pendiente

## Qué aprendí

## Problemas encontrados y solución

## Preguntas de entrevista
- **¿Qué es una llave foránea y para qué sirve?** Es una columna que referencia la llave primaria de otra tabla, y sirve para mantener la integridad relacional entre ambas (ej. que una lectura no pueda existir sin un dispositivo asociado).
- **¿Cuál es la diferencia entre INNER JOIN y LEFT JOIN?** INNER JOIN devuelve solo las filas que tienen coincidencia en ambas tablas; LEFT JOIN devuelve todas las filas de la tabla izquierda, con NULL en las columnas de la derecha cuando no hay coincidencia.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
