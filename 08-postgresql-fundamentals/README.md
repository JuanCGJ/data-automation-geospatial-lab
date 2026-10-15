# Proyecto 8 — PostgreSQL desde cero

> Estado: completado

## Objetivo
Aprender los fundamentos de bases de datos relacionales y SQL básico usando PostgreSQL.

## Requisitos
Contenedor de PostgreSQL corriendo (del Proyecto 0, base de datos `gisdb`); DBeaver conectado. Los datos de prueba se basan en los activos del Proyecto 5 (cámaras, postes y sensores).

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
2. Crear el esquema `monitoreo` en `gisdb` con 2 tablas relacionadas por FK: `activos` y `lecturas`.
3. Insertar datos de prueba en ambas tablas.
4. Escribir 5 queries que incluyan al menos un JOIN, una agregación y un filtro.
5. Guardar todo en un script `.sql` y tomar capturas de los resultados de cada query.

## Progreso (checklist)
- [x] **8.1** — Consultar y escribir qué son: base de datos, esquema, tabla, llave primaria (PK), llave foránea (FK) e índice. Evidencia: [hallazgos](evidence/hallazgos.md)
- [x] **8.2** — Crear el esquema `monitoreo` en `gisdb` con 2 tablas relacionadas por FK: `activos` y `lecturas`. Evidencia: [hallazgos](evidence/hallazgos.md)
- [x] **8.3** — Insertar datos de prueba en ambas tablas. Evidencia: [hallazgos](evidence/hallazgos.md)
- [x] **8.4** — Escribir 5 queries que incluyan al menos un JOIN, una agregación y un filtro. Evidencia: [hallazgos](evidence/hallazgos.md)
- [x] **8.5** — Guardar todo en un script `.sql` y tomar capturas de los resultados de cada query. Evidencia: [script](sql/monitoreo.sql), [hallazgos](evidence/hallazgos.md)

## Qué aprendí
- La jerarquía de PostgreSQL: servidor → base de datos → esquema → tabla.
- Separar los datos en tablas relacionadas por PK y FK evita duplicados, y la FK impide datos huérfanos (lo comprobé insertando una lectura de un activo inexistente).
- Escribir scripts idempotentes con `IF NOT EXISTS`, y por qué los `INSERT` no lo son.
- Guardar el archivo no cambia la base de datos: solo ejecutar lo hace.
- `JOIN` combina tablas por la FK; `GROUP BY` resume; `HAVING` filtra grupos; `CASE` clasifica; una subconsulta evita escribir valores a mano.
- Un promedio puede esconder un problema: hay que mirar también mínimos y máximos.
- El modelo de datos tiene que tener sentido en el mundo real: un poste común no genera lecturas, por eso se usó `poste_inteligente` y señal de conexión en lugar de batería.

## Problemas encontrados y solución
**8.2 — `relation "activos" already exists` al volver a ejecutar el script.** Los `CREATE TABLE` no tenían `IF NOT EXISTS`. Solución: agregar `IF NOT EXISTS` a tablas e índice, y ejecutar solo el bloque nuevo (`Ctrl + Enter` sobre la selección).

**8.3 — Columna que no tenía sentido para todos los activos.** `bateria_pct` no aplicaba a postes ni cámaras. Solución: renombrarla a `senal_pct` con `ALTER TABLE ... RENAME COLUMN` y usar el tipo `poste_inteligente`.

## Preguntas de entrevista
- **¿Qué es una llave foránea y para qué sirve?** Es una columna que referencia la llave primaria de otra tabla, y sirve para mantener la integridad relacional entre ambas (ej. que una lectura no pueda existir sin un activo asociado).
- **¿Cuál es la diferencia entre INNER JOIN y LEFT JOIN?** INNER JOIN devuelve solo las filas que tienen coincidencia en ambas tablas; LEFT JOIN devuelve todas las filas de la tabla izquierda, con NULL en las columnas de la derecha cuando no hay coincidencia.
- **¿Cuál es la diferencia entre WHERE y HAVING?** WHERE filtra filas antes de agrupar; HAVING filtra los grupos después de agrupar, así que puede usar funciones como `MAX()` o `AVG()`. Por ejemplo, para encontrar activos cuya señal cayó más de 10 puntos hace falta HAVING, porque la caída solo existe después de agrupar por activo.
- **¿Cuándo crearías un índice?** Sobre columnas por las que se filtra o busca con frecuencia, como la fecha en una tabla de lecturas. Acelera las consultas, pero ocupa espacio y hace un poco más lentas las escrituras, así que no se indexa todo.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
- `hallazgos.md`: hallazgos de los 5 ejercicios, con sus capturas.
- `8.2-diagrama-er.png`: diagrama entidad-relación del esquema `monitoreo`.
- `8.3-lecturas.png`, `8.3-error-fk.png`: datos insertados y prueba de la FK.
- `8.4-consulta1-filtro.png` … `8.4-consulta5-alertas.png`: resultado de cada consulta.
- `sql/monitoreo.sql`: script completo del proyecto (fuera de `evidence/`).