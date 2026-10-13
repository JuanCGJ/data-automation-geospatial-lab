# Proyecto 6 — Hallazgos

## 6.1 — Tipos de simbología en QGIS

La **simbología** define cómo se dibuja cada entidad (color, tamaño, forma). Se configura en *Propiedades de la capa → Symbology*, y el tipo se elige en el desplegable superior. **No modifica los datos**: solo cambia cómo se ven.

| Tipo | Qué hace | Tipo de campo | Ejemplo en este curso |
|---|---|---|---|
| **Símbolo único** (*Single Symbol*) | Todas las entidades con el mismo estilo | Ninguno | Las comunas en un solo color, como hasta ahora |
| **Categorizado** (*Categorized*) | Un color o símbolo por cada **valor distinto** de un campo | Texto o códigos (categorías) | Los activos por `tipo`: cámara, poste, sensor |
| **Graduado** (*Graduated*) | Divide un campo **numérico** en rangos (clases) y asigna un color o tamaño a cada rango | Numérico | Las comunas por `area_km2`, de claro (pequeñas) a oscuro (grandes) |

### Conceptos clave
- **Categorizado vs. graduado:** categorizado responde "¿de qué tipo es?"; graduado responde "¿cuánto tiene?". Usar graduado con categorías (o al revés) produce un mapa engañoso.
- **Paleta de colores:** en categorizado, colores distintos sin orden (cualitativos); en graduado, una escala de un solo tono de claro a oscuro (secuencial), para que "más oscuro" se lea como "más".
- **Modo de clasificación (graduado):** define cómo se cortan los rangos. Los más comunes son *Equal Interval* (rangos del mismo ancho), *Quantile* (la misma cantidad de entidades en cada rango) y *Natural Breaks (Jenks)* (cortes donde los datos tienen saltos naturales).
- **Etiquetas (*Labels*):** texto que muestra el valor de un campo sobre cada entidad. Se configuran aparte de la simbología, en la pestaña *Labels*.
