# Proyecto 10 — n8n desde cero

> Estado: pendiente

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

## Qué aprendí

## Problemas encontrados y solución

## Preguntas de entrevista
- **¿Qué diferencia hay entre un trigger de tipo schedule y uno de tipo webhook?** Schedule dispara el workflow en intervalos de tiempo definidos (ej. cada hora); webhook lo dispara en el momento en que llega una petición HTTP externa, en tiempo real.
- **¿Para qué sirven las expressions en n8n?** Para referenciar y transformar datos que vienen de un nodo anterior dentro de la configuración de otro nodo, sin necesidad de código adicional.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
