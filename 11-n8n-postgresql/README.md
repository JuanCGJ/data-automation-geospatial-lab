# Proyecto 11 — n8n + PostgreSQL

> Estado: completado

## Objetivo
Conectar n8n con PostgreSQL para automatizar el guardado de datos externos.

## Requisitos
Contenedores de n8n y PostgreSQL corriendo; credenciales de PostgreSQL configuradas en n8n; el workflow "Hello n8n" del Proyecto 10.

## Entregable
Workflow exportado (JSON) + captura de los datos guardados en la tabla.

## Conceptos
**Nodo de PostgreSQL en n8n:** permite ejecutar operaciones (insert, update, select) directamente contra una base de datos desde el workflow.

**Credenciales en n8n:** configuración reutilizable de conexión (host, usuario, contraseña) que se referencia desde cualquier nodo que la necesite.

**Automatización con trigger schedule:** permite que un workflow se ejecute periódicamente sin intervención manual (ej. guardar el clima cada hora).

## Ejercicios
1. Configurar en n8n las credenciales de conexión a PostgreSQL.
2. Duplicar el workflow "Hello n8n" del ejercicio 10.2 (schedule → API de clima) para usarlo como base, en lugar de construirlo de nuevo.
3. Agregar un nodo de PostgreSQL que inserte automáticamente los datos recibidos en una tabla.
4. Ejecutar el workflow y verificar en DBeaver que los datos se guardaron correctamente.

## Progreso (checklist)
- [x] **11.1** — Configurar en n8n las credenciales de conexión a PostgreSQL. Evidencia: [hallazgos](evidence/hallazgos.md)
- [x] **11.2** — Duplicar el workflow "Hello n8n" del ejercicio 10.2 (schedule → API de clima) para usarlo como base, en lugar de construirlo de nuevo. Evidencia: [hallazgos](evidence/hallazgos.md)
- [x] **11.3** — Agregar un nodo de PostgreSQL que inserte automáticamente los datos recibidos en una tabla. Evidencia: [script](sql/create_table.sql), [hallazgos](evidence/hallazgos.md)
- [x] **11.4** — Ejecutar el workflow y verificar en DBeaver que los datos se guardaron correctamente. Evidencia: [workflow](workflows/weather-to-postgresql.json), [hallazgos](evidence/hallazgos.md)

## Qué aprendí
- A crear credenciales de PostgreSQL en n8n: entre contenedores el host es el nombre del servicio de Docker (`postgis`) y el puerto el interno (5432), no `localhost`.
- Que n8n guarda las contraseñas cifradas en su propia base de datos y el workflow exportado solo referencia la credencial, por eso se puede versionar en GitHub.
- A reutilizar un workflow duplicándolo, en lugar de reconstruirlo.
- La diferencia entre desactivar un nodo (se salta en la ejecución) y no publicar un workflow (no corre solo, pero sí a mano).
- A diseñar la tabla destino según el JSON de n8n (`String` → `TEXT`, `Number` → `NUMERIC`) y a insertar con el nodo Postgres usando mapeo automático, que funciona cuando los nombres de los campos coinciden con las columnas.
- La diferencia entre `TIMESTAMP` y `TIMESTAMPTZ`, y a convertir columnas existentes con `ALTER ... USING ... AT TIME ZONE` sin desplazar la hora.
- A enviar fechas con zona explícita desde n8n con Luxon (`DateTime.fromISO(...).toISO()`).

## Problemas encontrados y solución
**11.4 — Fechas en zonas distintas.** `fecha_hora` llegaba en hora de Colombia, pero `creado_en` se guardaba en UTC (zona del contenedor de PostgreSQL): la misma fila mostraba 19:15 del día 2 y 00:28 del día 3, sin ninguna marca de zona. Solución: convertir ambas columnas a `TIMESTAMPTZ` con `ALTER TABLE ... USING ... AT TIME ZONE`.

**11.4 — Las filas nuevas iban a quedar 5 horas corridas.** n8n enviaba `fecha_hora` sin zona y, en una columna `TIMESTAMPTZ`, PostgreSQL la interpretaba en UTC. Solución: en *Edit Fields*, `DateTime.fromISO($json.current.time, { zone: $json.timezone }).toISO()`, que envía la hora con su zona (`-05:00`).

## Preguntas de entrevista
- **¿Qué ventaja tiene automatizar el guardado de datos con n8n en vez de hacerlo manualmente?** Elimina el trabajo repetitivo, reduce el error humano y garantiza que los datos se recolecten de forma consistente incluso sin supervisión.
- **¿Qué pasaría si la API externa falla? ¿Cómo lo manejarías en el workflow?** Se puede agregar manejo de errores (nodo de error / retry) para reintentar la llamada o registrar el fallo, en vez de dejar que el workflow se detenga silenciosamente.
- **¿Por qué n8n no se conecta a PostgreSQL usando `localhost`?** Cada contenedor tiene su propia red; `localhost` dentro de n8n es el contenedor de n8n. Docker Compose crea una red compartida donde cada servicio se resuelve por su nombre, así que el host es el nombre del servicio y el puerto el interno.
- **¿Dónde guarda n8n las contraseñas?** En credenciales cifradas dentro de su propia base de datos. Los workflows solo las referencian, por eso puedo versionar los JSON en GitHub sin exponer secretos.
- **¿TIMESTAMP o TIMESTAMPTZ?** TIMESTAMPTZ. Guarda un instante absoluto y evita ambigüedades cuando los datos vienen de fuentes o servidores en zonas distintas. Lo comprobé en este proyecto: PostgreSQL estaba en UTC y la API en hora de Colombia, y la misma fila parecía tener horas de días distintos.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
- `hallazgos.md`: hallazgos de los 4 ejercicios, con sus capturas.
- `11.1-credencial-postgres.png`: credencial `gisdb-local` creada y conexión probada.
- `11.2-workflow-duplicado.png`: campos del workflow duplicado "Weather to PostgreSQL".
- `11.3-nodo-postgres.png`: nodo Postgres configurado.
- `11.4-workflow-ejecutado.png`: ejecución completa del workflow.
- `11.4-resultado-dbeaver.png`, `11.4-resultado-dbeaver-timestamptz.png`, `11.4-insercion-con-zona.png`: primera inserción con el problema de zona horaria, la corrección a `TIMESTAMPTZ` y una fila nueva con zona explícita.
- `sql/create_table.sql`: script de la tabla. `workflows/weather-to-postgresql.json`: workflow exportado (fuera de `evidence/`).
