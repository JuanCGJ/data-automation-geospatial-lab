# Glosario — Proyecto 1: Fundamentos GIS

## Dato espacial vs no espacial
Un **dato espacial** es aquel que tiene una ubicación asociada en el mundo real, representada mediante coordenadas (ej. la ubicación de un hospital, el trazado de una calle, el polígono de un barrio). Un **dato no espacial** es un valor o atributo que no tiene esa ubicación por sí solo — es solo información descriptiva (ej. el nombre del hospital, su número de camas). En un GIS, los datos no espaciales normalmente están asociados a un dato espacial (una geometría) a través de la tabla de atributos.

## Capa
Una **capa (layer)** es un conjunto de entidades geográficas del mismo tipo, que se carga, visualiza y gestiona como una sola unidad dentro de un software GIS (ej. QGIS). Por ejemplo, "Barrios de la ciudad" es una capa donde cada entidad es un polígono que representa un barrio. Un proyecto GIS normalmente combina varias capas (barrios, calles, hospitales) para analizarlas juntas.

## Atributo
Un **atributo** es la información no geométrica asociada a una entidad de una capa. Se guarda en la tabla de atributos, donde cada fila es una entidad y cada columna es un atributo (ej. para la capa "Barrios": nombre del barrio, población, área en km²). Los atributos permiten hacer preguntas sobre los datos sin depender únicamente de la forma o ubicación (ej. "¿qué barrios tienen más de 10.000 habitantes?").

## Coordenadas
Las **coordenadas** son los valores numéricos que ubican un punto en el espacio. En geografía se suelen expresar como (latitud, longitud) — un sistema angular basado en la posición sobre la esfera terrestre — o como (x, y) en sistemas proyectados (metros, por ejemplo). Toda geometría en un GIS (punto, línea o polígono) está definida, en el fondo, por una o varias coordenadas.
