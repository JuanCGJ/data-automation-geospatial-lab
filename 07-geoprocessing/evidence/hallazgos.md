# Proyecto 7 — Hallazgos

## 7.1 — Herramientas de geoprocesamiento

El **geoprocesamiento** crea capas **nuevas** a partir de relaciones espaciales entre capas existentes. Ninguna de estas herramientas modifica las capas de entrada: siempre generan una salida. En QGIS están en el menú *Vector → Geoprocessing Tools* y en la *Processing Toolbox*.

| Herramienta | Qué hace | Ejemplo con datos de Manizales |
|---|---|---|
| **Buffer** | Crea un polígono (zona de influencia) alrededor de cada entidad, a una distancia dada | Área a 1 km de la Universidad de Caldas |
| **Clip** | Recorta una capa usando el contorno de otra; la salida solo conserva los atributos de la capa recortada | Quedarse solo con los activos que caen dentro del buffer |
| **Dissolve** | Fusiona entidades en una sola, opcionalmente agrupando por un atributo, y borra las fronteras internas | Unir las 12 comunas en un solo polígono: el perímetro urbano |
| **Intersect** | Devuelve solo las áreas donde dos capas se superponen, con los atributos de **ambas** | Qué partes de qué comunas quedan dentro del buffer |
| **Union** | Combina dos capas conservando **todas** las áreas, se superpongan o no, con los atributos de ambas | Comunas divididas en "dentro del buffer" y "fuera del buffer" |
| **Spatial join** (*Join attributes by location*) | Copia atributos de una capa a otra según su relación espacial, **sin cambiar la geometría** | Agregar a cada activo el nombre de la comuna en la que está |

### Conceptos clave
- **Clip vs. Intersect:** las dos devuelven solo la zona común, pero Clip usa la segunda capa como "molde" y descarta sus atributos; Intersect conserva los atributos de las dos.
- **Intersect vs. Union:** Intersect se queda con lo común; Union se queda con todo y lo parte donde las capas se cruzan.
- **Spatial join vs. el resto:** es el único que no crea geometrías nuevas, solo agrega columnas. Es el equivalente espacial de un `JOIN` en SQL.
- **La distancia del buffer usa las unidades del CRS:** en un CRS en grados (EPSG:4326), un buffer de "1000" serían 1000 grados. Por eso hay que trabajar en un CRS métrico, como EPSG:6256.
