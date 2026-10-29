# Proyecto 10 — n8n desde cero

> Estado: completado

## Objetivo
Aprender los conceptos básicos de n8n y construir tus primeros workflows de automatización.

## Requisitos
Contenedor de n8n corriendo (del Proyecto 0).

## Entregable
Exportar (JSON) los 2 workflows creados + capturas de su ejecución.

## Conceptos
**Workflow:** el flujo completo de automatización, compuesto por nodos conectados entre sí.

**Node:** cada bloque de un workflow que realiza una acción (traer datos, transformar, guardar, etc.).

**Trigger:** el nodo que inicia el workflow (ej. `schedule` por tiempo, `webhook` por una petición externa).

**HTTP request:** nodo que llama a una API externa.

**Webhook:** una URL expuesta por n8n que, al recibir una petición, dispara el workflow.

**JSON:** el formato de datos que fluye entre nodos en n8n.

**Expressions:** sintaxis (`{{ }}`) para referenciar datos de un nodo anterior dentro de otro nodo.

**Nodo IF:** permite ramificar el workflow según una condición lógica.

## Ejercicios
1. Consultar y escribir qué son: workflow, node, trigger, HTTP request, webhook, expression y el nodo IF.
2. Crear un workflow "Hello n8n": un trigger de tipo schedule → un nodo HTTP request a una API pública (ej. Open-Meteo) → un nodo que transforme el JSON recibido.
3. Crear un segundo workflow con un trigger de tipo webhook que reciba datos y responda con un mensaje.
4. Exportar ambos workflows como JSON.

## Progreso (checklist)
- [x] **10.1** — Consultar y escribir qué son: workflow, node, trigger, HTTP request, webhook, expression y el nodo IF. Evidencia: [hallazgos](evidence/hallazgos.md)
- [x] **10.2** — Crear un workflow "Hello n8n": un trigger de tipo schedule → un nodo HTTP request a una API pública (ej. Open-Meteo) → un nodo que transforme el JSON recibido. Evidencia: [hallazgos](evidence/hallazgos.md)
- [x] **10.3** — Crear un segundo workflow con un trigger de tipo webhook que reciba datos y responda con un mensaje. Evidencia: [hallazgos](evidence/hallazgos.md)
- [x] **10.4** — Exportar ambos workflows como JSON. Evidencia: [hallazgos](evidence/hallazgos.md)

## Qué aprendí
- A construir workflows en n8n conectando nodos: un trigger que inicia, nodos que traen o transforman datos y un nodo que responde.
- A consumir una API pública (Open-Meteo) con el nodo HTTP Request y a leer su respuesta en JSON.
- A transformar un JSON anidado en un item plano con *Edit Fields* y expressions (`{{ $json.current.temperature_2m }}`), dejando los datos con la forma de una fila de base de datos.
- La diferencia entre un trigger por tiempo (schedule, *pull*) y uno por evento (webhook, *push*), y entre las URL de prueba y de producción del webhook.
- A probar un webhook desde la terminal con `Invoke-RestMethod` y a responderle con *Respond to Webhook*.
- Que al integrar sistemas hay que fijar la zona horaria en cada uno, y que se configura en Docker con variables de entorno sin perder datos gracias a los volúmenes.
- A exportar los workflows como JSON para versionarlos en GitHub.

## Problemas encontrados y solución
**10.2 — n8n usaba la zona horaria de Nueva York.** El Schedule Trigger mostraba `America/New_York` (valor por defecto). Solución: variables `GENERIC_TIMEZONE` y `TZ` en `America/Bogota` en `docker-compose.yml` y `docker compose up -d`.

## Preguntas de entrevista
- **¿Qué diferencia hay entre un trigger de tipo schedule y uno de tipo webhook?** Schedule dispara el workflow en intervalos de tiempo definidos (ej. cada hora); webhook lo dispara en el momento en que llega una petición HTTP externa, en tiempo real.
- **¿Para qué sirven las expressions en n8n?** Para referenciar y transformar datos que vienen de un nodo anterior dentro de la configuración de otro nodo, sin necesidad de código adicional.
- **¿Cómo probarías un webhook antes de ponerlo en producción?** Con la URL de prueba: pongo el workflow a escuchar con *Execute workflow* y le envío una petición desde la terminal (`Invoke-RestMethod` o `curl`) con datos de ejemplo. Reviso lo que llegó en `body` y la respuesta; cuando funciona, lo publico y uso la URL de producción.
- **¿Cómo versionas un workflow de n8n?** Lo exporto como JSON y lo subo a Git. Así queda el historial de cambios y cualquiera puede importarlo en su propia instancia; antes de subirlo reviso que no lleve datos sensibles.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
- `hallazgos.md`: hallazgos de los 4 ejercicios, con sus capturas.
- `10.2-http-request.png`, `10.2-edit-fields.png`, `10.2-workflow-completo.png`: workflow "Hello n8n" (respuesta de la API, transformación y ejecución completa).
- `10.2-timezone-bogota.png`: zona horaria de n8n corregida.
- `10.3-powershell-respuesta.png`, `10.3-webhook-recibido.png`: prueba del webhook desde PowerShell y datos recibidos en n8n.
- `workflows/hello-n8n.json`, `workflows/webhook-saludo.json`: workflows exportados.
