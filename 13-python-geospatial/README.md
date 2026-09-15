# Proyecto 13 — Python + datos geoespaciales

> Estado: pendiente

## Objetivo
Aprender a manipular datos geoespaciales con Python y conectarlos a PostgreSQL/PostGIS.

## Requisitos
Python instalado con geopandas, shapely y psycopg; contenedor de PostgreSQL+PostGIS corriendo.

## Entregable
Script de Python que lea una capa, calcule área/centroides y escriba los resultados a PostgreSQL/PostGIS.

## Conceptos
**Geopandas:** extiende pandas para trabajar con datos geoespaciales; un `GeoDataFrame` es como un DataFrame normal pero con una columna de geometría y operaciones espaciales nativas.

**Shapely:** librería que representa y opera geometrías (puntos, líneas, polígonos) en Python, usada internamente por geopandas.

**Psycopg:** driver que permite a Python conectarse y ejecutar comandos SQL directamente contra PostgreSQL.

## Ejercicios
1. Consultar y escribir qué son y para qué sirven las librerías geopandas, shapely y psycopg.
2. Instalar las librerías necesarias en un entorno virtual de Python.
3. Escribir un script que lea una capa (de proyectos anteriores) con geopandas y calcule el área y el centroide de cada entidad.
4. Escribir los resultados calculados a una tabla de PostgreSQL/PostGIS usando psycopg.

## Progreso (checklist)

## Qué aprendí

## Problemas encontrados y solución

## Preguntas de entrevista
- **¿Qué es un GeoDataFrame y en qué se diferencia de un DataFrame normal de pandas?** Es un DataFrame con una columna de geometría y operaciones espaciales nativas (área, distancia, intersección), mientras que un DataFrame normal solo maneja datos tabulares sin noción de ubicación.
- **¿Por qué conectarías Python directamente a PostgreSQL en vez de exportar/importar archivos manualmente?** Porque automatiza el flujo de punta a punta (leer, procesar, guardar) sin pasos manuales intermedios, reduciendo errores y permitiendo integrarlo en un pipeline más grande.

## Evidencia
En la carpeta `evidence/` de este proyecto se guarda la evidencia visual (capturas de pantalla y, cuando aplica, gifs o videos cortos) del trabajo realizado en cada ejercicio.
