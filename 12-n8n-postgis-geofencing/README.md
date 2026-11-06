# Proyecto 12 — n8n + PostGIS (Geofencing)

> Estado: completado

## Objetivo
Construir un sistema de geofencing: recibir coordenadas GPS vía webhook y validar si están dentro de una zona usando PostGIS.

## Requisitos
n8n y PostgreSQL+PostGIS corriendo; la capa de comunas cargada en PostGIS en el ejercicio 9.5, usada como zonas.

## Entregable
Workflow completo + demo en gif o video corto.

## Conceptos
**Geofencing:** técnica para detectar si una ubicación (punto GPS) está dentro o fuera de una zona geográfica definida, disparando una acción según el resultado.

**Webhook como entrada en tiempo real:** permite que un dispositivo o sistema externo envíe una coordenada al workflow en el momento en que ocurre, sin esperar un intervalo programado.

**ST_Contains para validar pertenencia espacial:** función de PostGIS que responde si una geometría (la zona) contiene a otra (el punto recibido).

## Ejercicios
1. Preparar coordenadas GPS de prueba dentro y fuera de Manizales, reutilizando `puntos_manizales.csv` del Proyecto 2 y agregando algunos puntos fuera de la ciudad.
2. Crear un webhook en n8n que reciba una coordenada (latitud/longitud).
3. Agregar un nodo que consulte PostGIS con `ST_Contains` para validar si la coordenada está dentro de alguna comuna.
4. Agregar lógica (nodo IF) que genere una alerta (registro en otra tabla o mensaje simulado) cuando la coordenada esté fuera de la zona.
5. Grabar un gif o video corto mostrando el workflow funcionando de principio a fin.

## Progreso (checklist)
- [x] **12.1** — Preparar coordenadas GPS de prueba dentro y fuera de Manizales, reutilizando `puntos_manizales.csv` del Proyecto 2 y agregando algunos puntos fuera de la ciudad. Evidencia: [datos](data/coordenadas_prueba.csv), [hallazgos](evidence/hallazgos.md)
- [x] **12.2** — Crear un webhook en n8n que reciba una coordenada (latitud/longitud). Evidencia: [hallazgos](evidence/hallazgos.md)
- [x] **12.3** — Agregar un nodo que consulte PostGIS con `ST_Contains` para validar si la coordenada está dentro de alguna comuna. Evidencia: [script](sql/geofencing.sql), [hallazgos](evidence/hallazgos.md)
- [x] **12.4** — Agregar lógica (nodo IF) que genere una alerta (registro en otra tabla o mensaje simulado) cuando la coordenada esté fuera de la zona. Evidencia: [workflow](workflows/geofencing-manizales.json), [hallazgos](evidence/hallazgos.md)
- [x] **12.5** — Grabar un gif o video corto mostrando el workflow funcionando de principio a fin. Evidencia: [GIF](evidence/12.5-demo-geofencing.gif), [video](evidence/12.5-demo-geofencing.mp4), [hallazgos](evidence/hallazgos.md)

## Qué aprendí
- A probar un geofencing con casos dentro, fuera y **de borde** (Villamaría, pegada a Manizales), con una columna `esperado` para verificar el resultado.
- Que un GPS envía coordenadas en WGS 84 (EPSG:4326) y hay que transformarlas al CRS de las zonas (`ST_Transform` a EPSG:6256) antes de usar `ST_Contains`; y que `ST_MakePoint` recibe primero la longitud (x) y luego la latitud (y).
- A guardar la contraseña de PostgreSQL en QGIS con el gestor de autenticación (cifrada), en vez de la pestaña *Basic* (texto plano que se copia en las capas y en el proyecto).
- A recibir datos por webhook con POST y leerlos en `$json.body`, y que un webhook con *Using 'Respond to Webhook' Node* necesita ese nodo para responder.
- A usar `LEFT JOIN` + `IS NOT NULL` para que una consulta espacial siempre devuelva una fila con un booleano `dentro`, y a validar varios puntos a la vez con `WITH ... AS (VALUES ...)`.
- A usar **parámetros de consulta** (`$1`, `$2`) en n8n para evitar inyección SQL, y `$('Nombre del nodo')` para leer datos de un nodo anterior que no es el inmediato.
- A ramificar un workflow con el nodo IF y hacer que las dos ramas terminen en el mismo *Respond to Webhook*.
- A insertar geometrías calculadas con `INSERT ... RETURNING`, a leerlas con `ST_AsText` (WKT en lugar del binario EWKB) y a limpiar datos de prueba con `TRUNCATE ... RESTART IDENTITY`.
- Que la Test URL de un webhook acepta una sola llamada por cada clic en *Execute workflow*.

## Problemas encontrados y solución
**12.1 — El CSV se leía como una sola columna en QGIS.** Causa probable: el archivo se guardó desde Excel, que en español agrega comillas a cada línea o usa `;`. Solución: volver a crear el CSV en un editor de texto plano (UTF-8).

**12.2 — `No Respond to Webhook node found in the workflow`.** El webhook estaba configurado para responder con ese nodo, pero aún no existía, y n8n rechazó la petición. Solución: agregar el nodo *Respond to Webhook*.

**12.3 — La respuesta seguía siendo el eco de la petición.** La prueba se hizo con *Respond to Webhook* todavía conectado directo al Webhook. Solución: dejar las conexiones en línea (Webhook → Validar en PostGIS → Respond) y volver a ejecutar; los datos visibles eran de una ejecución anterior.

**12.5 — Se subió una grabación de prueba.** El primer video subido era un intento anterior, en el que la segunda llamada falló con `404 ... not registered` por no hacer clic en *Execute workflow* antes. Solución: reemplazarlo por la toma final, verificando el contenido del video antes de subirlo.

## Preguntas de entrevista
- **¿Qué es geofencing y en qué casos de uso reales se aplica?** Es detectar si una ubicación entra o sale de una zona definida; se usa en logística (activos que salen de una ruta), seguridad (perímetros), marketing (notificaciones al entrar a una tienda), entre otros.
- **¿Por qué usar un webhook en vez de un trigger schedule para este caso?** Porque la validación debe ocurrir en el momento en que llega la coordenada (tiempo real), no esperar a un intervalo programado que podría llegar tarde para generar la alerta.
- **¿Por qué transformas la coordenada antes de usar `ST_Contains`?** Porque el GPS envía WGS 84 (EPSG:4326, grados) y las comunas están en EPSG:6256 (metros). Las funciones espaciales comparan coordenadas tal cual; con sistemas distintos el resultado sería incorrecto. Con `ST_SetSRID(..., 4326)` declaro el sistema del punto y con `ST_Transform(..., 6256)` lo llevo al de las zonas.
- **¿Cómo evitas inyección SQL si la coordenada viene de un sistema externo?** Con consultas parametrizadas: el SQL queda fijo con `$1` y `$2`, y los valores se envían aparte, así PostgreSQL los trata siempre como datos y nunca como código. Además los convierto con `::float8`, así que un valor que no sea número hace fallar la consulta en lugar de ejecutarse.
- **¿Por qué usaste `LEFT JOIN` y no `INNER JOIN` en la consulta espacial?** Con `INNER JOIN`, un punto fuera de todas las comunas devuelve cero filas, y en n8n un nodo sin items detiene el workflow, así que nunca se generaría la alerta. Con `LEFT JOIN` siempre hay una fila: la comuna es `NULL` cuando el punto está fuera, y de ahí sale el booleano `dentro` que evalúa el nodo IF.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
- `hallazgos.md`: hallazgos de los 5 ejercicios, con sus capturas.
- `12.1-coordenadas-manizales.png`, `12.1-coordenadas-regional.png`: coordenadas de prueba sobre las comunas (vista de la ciudad y vista regional).
- `12.2-webhook-recibido.png`, `12.2-powershell-respuesta.png`: coordenada recibida por el webhook y prueba desde PowerShell.
- `12.3-dbeaver-dentro.png`, `12.3-dbeaver-fuera.png`, `12.3-dbeaver-verificacion.png`: consulta `ST_Contains` en DBeaver (punto dentro, punto fuera y las 9 coordenadas de prueba).
- `12.3-nodo-postgis.png`, `12.3-powershell-dentro.png`, `12.3-powershell-fuera.png`: nodo *Validar en PostGIS* y respuestas del workflow.
- `12.4-workflow-fuera.png`, `12.4-powershell-alerta.png`, `12.4-workflow-dentro.png`, `12.4-dbeaver-alertas.png`: rama de alerta, rama sin alerta y alertas registradas.
- `12.5-demo-geofencing.gif`, `12.5-demo-geofencing.mp4`: demo del workflow de principio a fin.
- `data/coordenadas_prueba.csv`, `sql/geofencing.sql`, `workflows/geofencing-manizales.json`: datos de prueba, script SQL y workflow exportado (fuera de `evidence/`).
