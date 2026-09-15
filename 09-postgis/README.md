# Proyecto 9 — PostGIS

> Estado: pendiente

## Objetivo
Aprender a extender PostgreSQL con PostGIS para guardar y consultar datos espaciales.

## Requisitos
Contenedor de PostgreSQL+PostGIS corriendo; tabla creada en el Proyecto 8.

## Entregable
Script `.sql` con las consultas espaciales y sus resultados.

## Conceptos
**Geometry vs geography:** `geometry` trabaja en un plano cartesiano (más rápido, requiere elegir una proyección adecuada); `geography` trabaja sobre la esfera terrestre (cálculos de distancia más precisos a nivel global, pero más costosos).

**SRID:** el identificador numérico del sistema de referencia espacial usado por una columna geometry/geography (equivalente al código EPSG).

**Índices espaciales (GiST):** estructuras que aceleran las consultas espaciales (ej. "qué está cerca de X"), igual que un índice normal acelera un `WHERE`.

**Funciones espaciales:** `ST_MakePoint` (crea un punto), `ST_Distance` (calcula distancia entre geometrías), `ST_DWithin` (¿está dentro de X distancia?), `ST_Contains` (¿una geometría contiene a otra?), `ST_Intersects` (¿se cruzan dos geometrías?), `ST_Buffer` (genera una zona de influencia).

## Ejercicios
1. Consultar y escribir la diferencia entre los tipos de dato geometry y geography, y qué es un SRID.
2. Consultar y escribir qué hace cada una de estas funciones: `ST_MakePoint`, `ST_Distance`, `ST_DWithin`, `ST_Contains`, `ST_Intersects`, `ST_Buffer`.
3. Agregar una columna `geometry` a una tabla existente e insertar puntos usando `ST_MakePoint`.
4. Escribir una consulta que devuelva qué puntos están a menos de 5 km de otro (usando `ST_DWithin` o `ST_Distance`).
5. Guardar las consultas y sus resultados en un script `.sql`.

## Progreso (checklist)
- [ ] **9.1** — Consultar y escribir la diferencia entre los tipos de dato geometry y geography, y qué es un SRID. Evidencia: pendiente
- [ ] **9.2** — Consultar y escribir qué hace cada una de estas funciones: `ST_MakePoint`, `ST_Distance`, `ST_DWithin`, `ST_Contains`, `ST_Intersects`, `ST_Buffer`. Evidencia: pendiente
- [ ] **9.3** — Agregar una columna `geometry` a una tabla existente e insertar puntos usando `ST_MakePoint`. Evidencia: pendiente
- [ ] **9.4** — Escribir una consulta que devuelva qué puntos están a menos de 5 km de otro (usando `ST_DWithin` o `ST_Distance`). Evidencia: pendiente
- [ ] **9.5** — Guardar las consultas y sus resultados en un script `.sql`. Evidencia: pendiente

## Qué aprendí

## Problemas encontrados y solución

## Preguntas de entrevista
- **¿Qué es un índice espacial y por qué mejora el rendimiento de las consultas?** Es una estructura (típicamente GiST) que permite descartar rápidamente las geometrías que claramente no cumplen una condición espacial, evitando comparar cada fila una por una.
- **¿Cuándo usarías geography en vez de geometry?** Cuando necesitas cálculos de distancia/área precisos sobre grandes extensiones (a nivel país o mundial), donde la curvatura de la Tierra afecta el resultado; para áreas pequeñas y mejor rendimiento, geometry con una proyección adecuada suele ser preferible.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
