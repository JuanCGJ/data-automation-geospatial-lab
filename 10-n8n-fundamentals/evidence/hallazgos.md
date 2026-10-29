# Proyecto 10 — Hallazgos

## 10.1 — Conceptos de n8n

**n8n** es una herramienta de automatización por nodos: en vez de escribir un programa, se conectan bloques visuales que traen, transforman y envían datos. En este curso corre en el contenedor Docker `gis-n8n` (http://localhost:5678).

| Concepto | Qué es | Ejemplo en este curso |
|---|---|---|
| **Workflow** | El flujo completo de automatización: nodos conectados que se ejecutan de izquierda a derecha | "Hello n8n" (10.2): traer el clima de Manizales cada hora |
| **Node (nodo)** | Cada bloque del workflow; hace una sola tarea (traer, transformar, decidir, guardar) | *HTTP Request*, *Edit Fields*, *IF*, *Postgres* |
| **Trigger** | El nodo que **inicia** el workflow; siempre va primero y no recibe datos de otro nodo | *Schedule Trigger* (por tiempo) o *Webhook* (por una petición) |
| **HTTP Request** | Nodo que llama a una **API** externa por internet y recibe su respuesta, normalmente en JSON | Pedir la temperatura actual a Open-Meteo |
| **Webhook** | Una **URL** que n8n expone y que, al recibir una petición, dispara el workflow; puede devolver una respuesta | Recibir una coordenada y responder si está dentro de Manizales (Proyecto 12) |
| **Expression** | Fórmula entre `{{ }}` que lee datos de un nodo anterior dentro de la configuración de otro nodo | `{{ $json.current.temperature_2m }}` |
| **Nodo IF** | Divide el workflow en dos salidas, **true** y **false**, según una condición | Si la señal < 30 % → rama de alerta (Proyecto 12) |

### Cómo viajan los datos
- Entre nodos viaja **JSON**: texto con pares `"campo": valor`, como una fila de una tabla. Ejemplo de una respuesta de Open-Meteo:
  ```json
  { "latitude": 5.06, "longitude": -75.5, "current": { "temperature_2m": 18.4 } }
  ```
- n8n agrupa los datos en **items**: cada item es un registro (como una fila). Un nodo se ejecuta **una vez por cada item** que recibe.
- `$json` en una expression es el item actual; `$('Nombre del nodo')` permite leer la salida de un nodo anterior específico.

### Schedule vs. webhook
| | Schedule Trigger | Webhook |
|---|---|---|
| Se dispara | Por **tiempo** (cada hora, todos los días a las 7 a.m.) | Cuando **alguien llama** a su URL |
| Modelo | *Pull*: n8n va a buscar los datos | *Push*: otro sistema le envía los datos |
| Uso típico | Reportes, sincronizaciones periódicas | Formularios, eventos en tiempo real, integraciones |

### Conceptos clave
- **Ejecución manual vs. activa:** mientras se construye, el workflow se prueba a mano (*Execute workflow*). Para que corra solo (por schedule o webhook de producción) hay que **activarlo**.
- **URL de prueba vs. de producción del webhook:** la de prueba solo escucha mientras se está probando en el editor; la de producción funciona cuando el workflow está activo.
- **Relación con lo anterior:** n8n será el "pegamento" del curso. En el Proyecto 11 escribirá en PostgreSQL y en el 12 consultará PostGIS (`ST_Contains`) para validar coordenadas.
