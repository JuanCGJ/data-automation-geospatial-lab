# Sistema de alerta temprana por deslizamientos en Manizales

**Capstone — Proyecto 14** · Documento de escenario, uso de los datos y fuentes · Noviembre 2026

## 1. Contexto
Manizales está construida sobre un filo de montaña, con pendientes fuertes y una lluvia media cercana a **2.500 mm al año** en dos temporadas de lluvias. Los deslizamientos son su principal amenaza natural: entre **1960 y 1998 se registraron 518**, la mayoría en la ladera de Olivares (comuna San José), y eventos como los de San Fernando (1982), San Cayetano y La Carolita (1993) y La Sultana (2003) dejaron víctimas mortales [2]. La ciudad gestiona este riesgo con alertas en temporada de lluvias [1].

## 2. Qué encontramos
**Un indicador de lluvia oficial.** La oficina de gestión del riesgo de la ciudad (OMPAD) usa el indicador **A25**: la lluvia acumulada de los **últimos 25 días**. Su umbral para establecer alertas en temporada de lluvias es **200 mm** [1]. La lluvia que detona un deslizamiento no es solo la de un aguacero: es la que el suelo ha ido acumulando.

**Las comunas más susceptibles con respaldo publicado:**

| Comuna | Evidencia | Fuente |
|---|---|---|
| 1 – Atardeceres | Sector occidental: la zona más lluviosa de la ciudad en el registro histórico; foco de los estudios de deslizamientos | [1] |
| 11 – La Macarena | Mismo sector occidental | [1] |
| 2 – San José | Ladera de Olivares: la mayor parte de los 518 deslizamientos de 1960–1998 | [2], [3] |

Para las otras 9 comunas no se encontró evidencia publicada verificable. Las fuentes nombran barrios con eventos históricos, pero no se usaron para clasificar comunas sin una fuente que confirme a qué comuna pertenece cada barrio.

## 3. Datos de susceptibilidad: Servicio Geológico Colombiano
Se descargó el **Mapa Nacional de Susceptibilidad por Movimientos en Masa del SGC** (versión 2, 2019, escala 1:100.000) [4]: un **raster** (`SuscMM_100k.tif`, ~180 MB, todo el país) en el que cada celda tiene una clase de susceptibilidad, descrita en su tabla de valores (`.vat.dbf`). Con **estadística zonal** en QGIS se obtiene la clase predominante de cada una de las 12 comunas. Así **todas** las comunas quedan clasificadas con un dato oficial, sin asumir niveles, y las 3 comunas con evidencia publicada (sección 2) sirven para **validar** el resultado.

## 4. Cómo lo usaremos
**Riesgo = detonante (lluvia) × condición del terreno (susceptibilidad).** La lluvia es casi igual en toda la ciudad; lo que diferencia a las comunas es su terreno. Por eso el umbral es **inverso** a la susceptibilidad: un terreno más frágil se desliza con menos lluvia acumulada.

| Susceptibilidad (SGC) | Umbral A25 |
|---|---|
| Alta / muy alta | 150 mm *(supuesto)* |
| Media | **200 mm** (oficial OMPAD [1]) |
| Baja / muy baja | 250 mm *(supuesto)* |

- **Datos:** la estadística zonal genera la susceptibilidad de cada comuna, que se guarda en PostGIS junto con su umbral y la fuente del dato.
- **Lluvia:** n8n consulta Open-Meteo en el punto interior de cada comuna (Proyecto 13), suma la lluvia diaria de los últimos 25 días (A25) y la compara con el umbral de la comuna → **alerta por comuna**.
- **Cobertura:** brigadas de emergencia simuladas reportan su posición por webhook; si una comuna en alerta no tiene una brigada cercana (`ST_DWithin`), se genera la alerta **"comuna en alerta sin cobertura"**.
- **Demo:** se reproduce un periodo histórico real de lluvias con los datos históricos de Open-Meteo.

## 5. Limitaciones
- Solo el umbral de 200 mm es oficial; los de 150 y 250 mm son **supuestos del proyecto** para que la susceptibilidad module la alerta.
- El mapa del SGC es **regional** (1:100.000): sirve para comparar comunas entre sí, no para evaluar el riesgo de un predio o una cuadra.
- Open-Meteo entrega datos en una cuadrícula de varios kilómetros: la lluvia será casi igual en todas las comunas. La arquitectura queda lista para datos más finos (por ejemplo, la red de estaciones de la UNAL [1]).
- Es un **ejercicio académico**: no reemplaza los sistemas de alerta oficiales de la ciudad.

## Fuentes
1. Instituto de Estudios Ambientales (IDEA), Universidad Nacional de Colombia – Sede Manizales. Artículo sobre umbrales de lluvia (A25, E95) y deslizamientos en el sector occidental de Manizales. https://idea.manizales.unal.edu.co/publicaciones/reportes_meteorologicos/red_manizales/documentos_y_publicaciones/articulos_en_seminarios_congresos/articulo4.pdf
2. Duque Escobar, G. (2023). *Amenaza climática, un reto complejo para Manizales.* https://godues.wordpress.com/2023/03/27/amenaza-climatica-un-reto-complejo-para-manizales/
3. *Riesgo por deslizamientos en suelos de la Comuna San José de Manizales.* https://www.researchgate.net/publication/385552148_Riesgo_por_deslizamientos_en_suelos_de_la_Comuna_San_Jose_de_Manizales
4. Servicio Geológico Colombiano (2019). *Mapa Nacional de Susceptibilidad por Movimientos en Masa*, v2, escala 1:100.000 (`SuscMM_2019web.zip`). https://www2.sgc.gov.co/sgc/mapas/Paginas/Imagenes-de-amenazas-.aspx
