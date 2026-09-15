# Proyecto 11 — n8n + PostgreSQL

> Estado: pendiente

## Objetivo
Conectar n8n con PostgreSQL para automatizar el guardado de datos externos.

## Requisitos
Contenedores de n8n y PostgreSQL corriendo; credenciales de PostgreSQL configuradas en n8n.

## Entregable
Workflow exportado (JSON) + captura de los datos guardados en la tabla.

## Conceptos
**Nodo de PostgreSQL en n8n:** permite ejecutar operaciones (insert, update, select) directamente contra una base de datos desde el workflow.

**Credenciales en n8n:** configuración reutilizable de conexión (host, usuario, contraseña) que se referencia desde cualquier nodo que la necesite.

**Automatización con trigger schedule:** permite que un workflow se ejecute periódicamente sin intervención manual (ej. guardar el clima cada hora).

## Ejercicios
1. Configurar en n8n las credenciales de conexión a PostgreSQL.
2. Crear un workflow con un trigger schedule (ej. cada hora) que llame a una API pública (ej. clima de tu ciudad).
3. Agregar un nodo de PostgreSQL que inserte automáticamente los datos recibidos en una tabla.
4. Ejecutar el workflow y verificar en DBeaver que los datos se guardaron correctamente.

## Progreso (checklist)

## Qué aprendí

## Problemas encontrados y solución

## Preguntas de entrevista
- **¿Qué ventaja tiene automatizar el guardado de datos con n8n en vez de hacerlo manualmente?** Elimina el trabajo repetitivo, reduce el error humano y garantiza que los datos se recolecten de forma consistente incluso sin supervisión.
- **¿Qué pasaría si la API externa falla? ¿Cómo lo manejarías en el workflow?** Se puede agregar manejo de errores (nodo de error / retry) para reintentar la llamada o registrar el fallo, en vez de dejar que el workflow se detenga silenciosamente.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
