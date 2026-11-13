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

## 3. Cómo lo usaremos
**Riesgo = detonante (lluvia) × condición del terreno (susceptibilidad).** La lluvia es casi igual en toda la ciudad; lo que diferencia a las comunas es su terreno.

| Susceptibilidad | Comunas | Base | Umbral A25 |
|---|---|---|---|
| Alta | 1, 2, 11 | Con fuente | 150 mm *(supuesto)* |
| Media | Las otras 9 | **Supuesto** a falta de datos | **200 mm** (oficial OMPAD [1]) |
| Baja | Ninguna | No se declaran comunas "seguras" sin evidencia | 250 mm *(supuesto)* |

- **Datos:** `data/susceptibilidad_comunas.csv`, con una columna `fuente` que indica si cada nivel tiene respaldo o es supuesto.
- **Lluvia:** n8n consulta Open-Meteo en el punto interior de cada comuna (Proyecto 13), suma la lluvia diaria de los últimos 25 días (A25) y la compara con el umbral de la comuna → **alerta por comuna**.
- **Cobertura:** brigadas de emergencia simuladas reportan su posición por webhook; si una comuna en alerta no tiene una brigada cercana (`ST_DWithin`), se genera la alerta **"comuna en alerta sin cobertura"**.
- **Demo:** se reproduce un periodo histórico real de lluvias con los datos históricos de Open-Meteo.

## 4. Limitaciones
- Los umbrales de 150 y 250 mm y el nivel "media" de 9 comunas son **supuestos del proyecto**, no clasificaciones oficiales.
- Open-Meteo entrega datos en una cuadrícula de varios kilómetros: la lluvia será casi igual en todas las comunas. La arquitectura queda lista para datos más finos (por ejemplo, la red de estaciones de la UNAL [1]).
- Es un **ejercicio de portafolio**: no reemplaza los sistemas de alerta oficiales de la ciudad.

## 5. Mejora prevista
Refinar la susceptibilidad de las 12 comunas con el **Mapa Nacional de Susceptibilidad por Movimientos en Masa del SGC** (v2, 2019, escala 1:100.000, formato raster) mediante estadística zonal [4].

## Fuentes
1. Instituto de Estudios Ambientales (IDEA), Universidad Nacional de Colombia – Sede Manizales. Artículo sobre umbrales de lluvia (A25, E95) y deslizamientos en el sector occidental de Manizales. https://idea.manizales.unal.edu.co/publicaciones/reportes_meteorologicos/red_manizales/documentos_y_publicaciones/articulos_en_seminarios_congresos/articulo4.pdf
2. Duque Escobar, G. (2023). *Amenaza climática, un reto complejo para Manizales.* https://godues.wordpress.com/2023/03/27/amenaza-climatica-un-reto-complejo-para-manizales/
3. *Riesgo por deslizamientos en suelos de la Comuna San José de Manizales.* https://www.researchgate.net/publication/385552148_Riesgo_por_deslizamientos_en_suelos_de_la_Comuna_San_Jose_de_Manizales
4. Servicio Geológico Colombiano. Mapas de amenazas y susceptibilidad por movimientos en masa. https://www2.sgc.gov.co/sgc/mapas/Paginas/Imagenes-de-amenazas-.aspx
