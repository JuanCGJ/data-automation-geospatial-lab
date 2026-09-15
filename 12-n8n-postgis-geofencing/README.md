# Proyecto 12 — n8n + PostGIS (Geofencing)

> Estado: pendiente

## Objetivo
Construir un sistema de geofencing: recibir coordenadas GPS vía webhook y validar si están dentro de una zona usando PostGIS.

## Requisitos
n8n y PostgreSQL+PostGIS corriendo; una tabla con al menos una zona (polígono) definida en PostGIS.

## Entregable
Workflow completo + demo en gif o video corto.

## Conceptos
**Geofencing:** técnica para detectar si una ubicación (punto GPS) está dentro o fuera de una zona geográfica definida, disparando una acción según el resultado.

**Webhook como entrada en tiempo real:** permite que un dispositivo o sistema externo envíe una coordenada al workflow en el momento en que ocurre, sin esperar un intervalo programado.

**ST_Contains para validar pertenencia espacial:** función de PostGIS que responde si una geometría (la zona) contiene a otra (el punto recibido).

## Ejercicios
1. Simular datos GPS (crear un CSV o un script simple en Python que genere coordenadas de ejemplo).
2. Crear un webhook en n8n que reciba una coordenada (latitud/longitud).
3. Agregar un nodo que consulte PostGIS con `ST_Contains` para validar si la coordenada está dentro de una zona definida.
4. Agregar lógica (nodo IF) que genere una alerta (registro en otra tabla o mensaje simulado) cuando la coordenada esté fuera de la zona.
5. Grabar un gif o video corto mostrando el workflow funcionando de principio a fin.

## Progreso (checklist)
- [ ] **12.1** — Simular datos GPS (crear un CSV o un script simple en Python que genere coordenadas de ejemplo). Evidencia: pendiente
- [ ] **12.2** — Crear un webhook en n8n que reciba una coordenada (latitud/longitud). Evidencia: pendiente
- [ ] **12.3** — Agregar un nodo que consulte PostGIS con `ST_Contains` para validar si la coordenada está dentro de una zona definida. Evidencia: pendiente
- [ ] **12.4** — Agregar lógica (nodo IF) que genere una alerta (registro en otra tabla o mensaje simulado) cuando la coordenada esté fuera de la zona. Evidencia: pendiente
- [ ] **12.5** — Grabar un gif o video corto mostrando el workflow funcionando de principio a fin. Evidencia: pendiente

## Qué aprendí

## Problemas encontrados y solución

## Preguntas de entrevista
- **¿Qué es geofencing y en qué casos de uso reales se aplica?** Es detectar si una ubicación entra o sale de una zona definida; se usa en logística (activos que salen de una ruta), seguridad (perímetros), marketing (notificaciones al entrar a una tienda), entre otros.
- **¿Por qué usar un webhook en vez de un trigger schedule para este caso?** Porque la validación debe ocurrir en el momento en que llega la coordenada (tiempo real), no esperar a un intervalo programado que podría llegar tarde para generar la alerta.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
