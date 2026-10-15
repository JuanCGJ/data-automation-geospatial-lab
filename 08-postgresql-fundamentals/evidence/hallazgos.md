# Proyecto 8 — Hallazgos

## 8.1 — Conceptos de bases de datos relacionales

Una base de datos relacional guarda los datos en **tablas relacionadas entre sí**. Es la misma idea de la tabla de atributos de QGIS, pero pensada para muchos usuarios, muchos datos y consultas con SQL.

La jerarquía en PostgreSQL es: **servidor → base de datos → esquema → tabla → filas y columnas**.

| Concepto | Qué es | En este curso |
|---|---|---|
| **Base de datos** | Contenedor de todos los datos de un sistema; cada conexión entra a una base de datos | `gisdb`, en el contenedor Docker `gis-postgres` |
| **Esquema** | Carpeta lógica dentro de una base de datos que agrupa tablas relacionadas; `public` es el esquema por defecto | `monitoreo`, para las tablas de este proyecto |
| **Tabla** | Filas (registros) y columnas (campos con un tipo de dato fijo) | `activos` y `lecturas` |
| **Llave primaria (PK)** | Columna que identifica cada fila de forma única; no se repite ni puede estar vacía | `activos.id_activo` |
| **Llave foránea (FK)** | Columna que apunta a la PK de otra tabla; crea la relación e impide referenciar algo que no existe | `lecturas.id_activo` → `activos.id_activo` |
| **Índice** | Estructura que acelera las búsquedas por una columna, a cambio de espacio y escrituras algo más lentas | Índice sobre `lecturas.fecha` para consultar por fechas |

### Relación entre las dos tablas
Un activo (por ejemplo, una cámara) tiene **muchas** lecturas a lo largo del tiempo; cada lectura pertenece a **un solo** activo. Es una relación **uno a muchos** (1:N):

```
activos (1) ──────< lecturas (N)
id_activo  PK        id_lectura  PK
tipo                 id_activo   FK → activos.id_activo
estado               fecha
                     valor
```

### Por qué separar en dos tablas
Si todo estuviera en una sola tabla, el tipo y el estado de cada activo se repetirían en cada lectura. Separarlas evita duplicados y errores de digitación: el dato del activo vive en un solo lugar (**normalización**).

### SQL básico
| Comando | Para qué | Equivalente en QGIS |
|---|---|---|
| `CREATE TABLE` | Crear una tabla con sus columnas y tipos | *New GeoPackage Layer* (5.2) |
| `INSERT` | Agregar filas | Digitalizar puntos (5.2) |
| `SELECT ... WHERE` | Consultar filas que cumplen una condición | Selección por expresión (4.3) |
| `JOIN` | Combinar filas de dos tablas por una columna común | *Join attributes* (7.1) |
| `GROUP BY` | Agrupar y resumir (contar, promediar, sumar) | Estadísticas por categoría |
