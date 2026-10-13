# Proyecto 6 — Simbología y visualización

> Estado: completado

## Objetivo
Aprender a simbolizar y etiquetar capas en QGIS para comunicar información visualmente.

## Requisitos
QGIS; la capa `activos` del Proyecto 5 (campo categórico `tipo`) y la capa de comunas del Proyecto 4 (campo numérico `area_km2`).

## Entregable
Mapa exportado como imagen usando el diseñador de impresión (layout) de QGIS.

## Conceptos
**Símbolo único:** toda la capa se muestra con el mismo estilo, sin distinguir entidades entre sí.

**Categorizado:** cada valor único de un campo (ej. tipo de uso de suelo) se muestra con un color/símbolo distinto.

**Graduado:** un campo numérico se divide en rangos, y cada rango tiene un color/tamaño distinto (ej. mapa de densidad).

**Etiquetas (labels):** texto mostrado sobre el mapa con el valor de un campo (ej. nombre de cada barrio).

## Ejercicios
1. Consultar y escribir la diferencia entre simbología de símbolo único, categorizado y graduado.
2. Simbolizar la capa `activos` por categoría según el campo `tipo`.
3. Simbolizar la capa de comunas por valor graduado según `area_km2`, y agregar etiquetas con el nombre de cada comuna.
4. Usar el diseñador de impresión (layout) de QGIS para exportar el mapa como imagen.

## Progreso (checklist)
- [x] **6.1** — Consultar y escribir la diferencia entre simbología de símbolo único, categorizado y graduado. Evidencia: [hallazgos](evidence/hallazgos.md)
- [x] **6.2** — Simbolizar la capa `activos` por categoría según el campo `tipo`. Evidencia: [hallazgos](evidence/hallazgos.md)
- [x] **6.3** — Simbolizar la capa de comunas por valor graduado según `area_km2`, y agregar etiquetas con el nombre de cada comuna. Evidencia: [hallazgos](evidence/hallazgos.md)
- [x] **6.4** — Usar el diseñador de impresión (layout) de QGIS para exportar el mapa como imagen. Evidencia: [hallazgos](evidence/hallazgos.md)

## Qué aprendí
- La simbología cambia cómo se ven los datos, no los datos en sí.
- Categorizado responde "¿de qué tipo es?" (campos de texto); graduado responde "¿cuánto tiene?" (campos numéricos).
- En graduado conviene una rampa de un solo tono, de claro a oscuro, que no empiece en blanco si el fondo es blanco.
- El modo de clasificación cambia el mensaje del mapa: *Natural Breaks (Jenks)* corta donde los datos tienen saltos, y por eso dejó a Tesorito sola en la clase más alta.
- Escribir valores de texto uniformes desde la captura de datos (5.2) es lo que permite que la simbología categorizada funcione.
- Las etiquetas se configuran aparte de la simbología, y un borde blanco (*buffer*) las hace legibles sobre colores oscuros.
- Un mapa profesional lleva título, leyenda, escala, norte y fuente con CRS, y se arma en el layout, no en el lienzo de trabajo.


## Problemas encontrados y solución
**6.4 — Los elementos del layout no eran proporcionales a la hoja.** Solución: fijar el tamaño de la página en *Page Properties* (A4, horizontal) antes de acomodar los elementos.

## Preguntas de entrevista
- **¿Cuándo usarías simbología graduada en vez de categorizada?** Graduada cuando el campo es numérico y quieres mostrar magnitud (como el área de las comunas, de claro a oscuro); categorizada cuando el campo es una categoría (como el tipo de activo: cámara, poste, sensor). Usar una por la otra produce un mapa engañoso.
- **¿Para qué sirve una consulta de definición (definition query)?** Para mostrar solo un subconjunto de entidades de una capa sin crear una capa nueva ni modificar los datos originales.
- **¿Qué elementos debe tener un mapa para presentarlo?** Título, leyenda, escala, flecha de norte y fuente de los datos con su CRS. Sin la fuente y el CRS, quien lo lee no puede verificarlo ni reutilizarlo.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
- `hallazgos.md`: hallazgos de los 4 ejercicios, con sus capturas.
- `6.2-categorizado.png`: activos simbolizados por tipo.
- `6.3-graduado-clases.png`, `6.3-etiquetas-config.png`: configuración de la simbología graduada y de las etiquetas.
- `6.3-graduado-etiquetas.png`: comunas graduadas por área, con etiquetas.
- `6.4-mapa-comunas.png`: mapa final exportado desde el layout.