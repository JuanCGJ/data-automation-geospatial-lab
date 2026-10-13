# Proyecto 5 — Hallazgos

## 5.1 — Herramientas de edición en QGIS

### Modo edición
QGIS protege las capas contra cambios accidentales: para modificar geometrías o atributos hay que activar el **modo edición** con el lápiz amarillo (*Toggle Editing*). Mientras está activo, los cambios quedan en memoria y solo se escriben en el archivo al hacer clic en **Save Layer Edits** (disquete). Si se sale del modo edición sin guardar, QGIS pregunta si se quieren descartar. Al activarlo aparece la barra de herramientas *Digitizing*.

### Herramientas
| Herramienta | Qué hace | Cómo se usa |
|---|---|---|
| **Add Point Feature** | Crea un punto nuevo | Un clic en el mapa y luego llenar sus atributos |
| **Add Line / Polygon Feature** | Crea una línea o un polígono nuevo | Clic en cada vértice y clic derecho para terminar; el polígono se cierra solo |
| **Vertex Tool** | Edita los vértices de una entidad existente | Arrastrar un vértice para moverlo; doble clic sobre un borde para agregar uno; seleccionarlo y presionar `Supr` para eliminarlo |
| **Move Feature** | Mueve una entidad completa sin deformarla | Clic sobre la entidad y clic en la nueva ubicación |
| **Delete Selected** | Elimina entidades | Seleccionarlas y presionar el bote de basura |
| **Split Features** | Corta una línea o polígono en varias partes | Dibujar una línea que cruce la entidad de lado a lado y clic derecho para terminar |
| **Merge Selected Features** | Une varias entidades en una sola | Seleccionarlas y elegir qué valores de atributos conserva la entidad resultante |

### Conceptos clave
- **Vértice:** cada esquina o punto de quiebre de una línea o polígono. El borde de una comuna puede tener cientos.
- **Mover un punto vs. mover un vértice:** un punto es una entidad completa (se mueve con *Move Feature*); un vértice es solo una parte de una línea o polígono (se mueve con *Vertex Tool*).
- **Split vs. Merge:** son operaciones inversas. Al dividir, las partes nuevas copian los atributos de la original; al unir, hay que decidir qué atributos se conservan.
