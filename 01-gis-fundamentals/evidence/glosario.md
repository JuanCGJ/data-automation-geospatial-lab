# Glosario — Proyecto 1: Fundamentos GIS

## Dato espacial vs no espacial
Un **dato espacial** es aquel que tiene una ubicación asociada en el mundo real, representada mediante coordenadas (ej. la ubicación de un hospital, el trazado de una calle, el polígono de un barrio). Un **dato no espacial** es un valor o atributo que no tiene esa ubicación por sí solo — es solo información descriptiva (ej. el nombre del hospital, su número de camas). En un GIS, los datos no espaciales normalmente están asociados a un dato espacial (una geometría) a través de la tabla de atributos.

## Capa
Una **capa (layer)** es un conjunto de entidades geográficas del mismo tipo, que se carga, visualiza y gestiona como una sola unidad dentro de un software GIS (ej. QGIS). Por ejemplo, "Barrios de la ciudad" es una capa donde cada entidad es un polígono que representa un barrio. Un proyecto GIS normalmente combina varias capas (barrios, calles, hospitales) para analizarlas juntas.

## Atributo
Un **atributo** es la información no geométrica asociada a una entidad de una capa. Se guarda en la tabla de atributos, donde cada fila es una entidad y cada columna es un atributo (ej. para la capa "Barrios": nombre del barrio, población, área en km²). Los atributos permiten hacer preguntas sobre los datos sin depender únicamente de la forma o ubicación (ej. "¿qué barrios tienen más de 10.000 habitantes?").

## Coordenadas
Las **coordenadas** son los valores numéricos que ubican un punto en el espacio. En geografía se suelen expresar como (latitud, longitud) — un sistema angular basado en la posición sobre la esfera terrestre — o como (x, y) en sistemas proyectados (metros, por ejemplo). Toda geometría en un GIS (punto, línea o polígono) está definida, en el fondo, por una o varias coordenadas.

## CRS (Coordinate Reference System)
Un **CRS** es el sistema que define cómo un conjunto de coordenadas se relaciona con ubicaciones reales sobre la superficie de la Tierra. Sin un CRS, un par de números (x, y) no significa nada — el CRS es el que le da contexto geográfico a esos números (qué forma de la Tierra se asume, qué unidad se usa, dónde está el origen). Dos capas con el mismo dato pero distinto CRS no se van a alinear correctamente en un mapa hasta que se reproyecten a un CRS en común.

## EPSG
**EPSG** es un catálogo estándar de códigos numéricos que identifican de forma única cada CRS (ej. EPSG:4326, EPSG:3116). En vez de describir manualmente todos los parámetros de un sistema de coordenadas, basta con referenciar su código EPSG para que cualquier software GIS sepa exactamente de qué sistema se trata.

## WGS84
**WGS84** (World Geodetic System 1984, EPSG:4326) es el sistema de referencia geográfico más usado a nivel mundial. Es el sistema que usa el GPS, y por eso es el estándar por defecto cuando se trabaja con coordenadas de latitud/longitud sin especificar otra cosa.

