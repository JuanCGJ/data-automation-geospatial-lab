# Proyecto 11 — n8n + PostgreSQL

> Estado: pendiente

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
- [x] **11.1** — Configurar en n8n las credenciales de conexión a PostgreSQL. Evidencia: pendiente
- [x] **11.2** — Duplicar el workflow "Hello n8n" del ejercicio 10.2 (schedule → API de clima) para usarlo como base, en lugar de construirlo de nuevo. Evidencia: pendiente
- [ ] **11.3** — Agregar un nodo de PostgreSQL que inserte automáticamente los datos recibidos en una tabla. Evidencia: pendiente
- [ ] **11.4** — Ejecutar el workflow y verificar en DBeaver que los datos se guardaron correctamente. Evidencia: pendiente

## Qué aprendí
Crear credenciales de PostgreSQL en n8n: entre contenedores el host es el nombre del servicio de Docker y el puerto el interno (5432), no localhost.
Reutilizar un workflow existente duplicándolo, en lugar de reconstruirlo.
Insertar datos con el nodo Postgres usando mapeo automático, que funciona cuando los nombres de los campos coinciden con las columnas.
La diferencia entre desactivar un nodo y no publicar un workflow en n8n.
TIMESTAMP vs TIMESTAMPTZ, y cómo enviar fechas con zona explícita desde n8n con Luxon.

## Problemas encontrados y solución
Fechas en zonas distintas: fecha_hora llegaba en hora de Colombia, pero creado_en se guardaba en UTC (zona del contenedor de Postgres), con 5 horas de diferencia sin ninguna marca. Solución: convertir ambas columnas a TIMESTAMPTZ con ALTER ... USING ... AT TIME ZONE y enviar fecha_hora desde n8n con zona explícita: DateTime.fromISO($json.current.time, { zone: $json.timezone }).toISO(). Evidencia: 11.4-resultado-dbeaver.png (antes) y 11.4-resultado-dbeaver-timestamptz.png / 11.4-insercion-con-zona.png (después).

## Preguntas de entrevista
- **¿Qué ventaja tiene automatizar el guardado de datos con n8n en vez de hacerlo manualmente?** Elimina el trabajo repetitivo, reduce el error humano y garantiza que los datos se recolecten de forma consistente incluso sin supervisión.
- **¿Qué pasaría si la API externa falla? ¿Cómo lo manejarías en el workflow?** Se puede agregar manejo de errores (nodo de error / retry) para reintentar la llamada o registrar el fallo, en vez de dejar que el workflow se detenga silenciosamente.
¿Por qué n8n no se conecta a Postgres usando localhost? — Cada contenedor tiene su propia red; localhost dentro de n8n es el contenedor de n8n. Docker Compose crea una red compartida donde cada servicio se resuelve por su nombre, así que el host es el nombre del servicio y el puerto el interno.
¿Dónde guarda n8n las contraseñas? — En credenciales cifradas dentro de su propia base de datos. Los workflows solo las referencian, por eso puedo versionar los JSON en GitHub sin exponer secretos.
¿TIMESTAMP o TIMESTAMPTZ? — TIMESTAMPTZ. Guarda un instante absoluto y evita ambigüedades cuando los datos vienen de fuentes o servidores en zonas distintas. Lo comprobé en este proyecto: el servidor estaba en UTC y la API en hora local.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
