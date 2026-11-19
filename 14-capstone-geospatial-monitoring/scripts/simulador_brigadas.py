"""
Proyecto 14 — Capstone / 14.6 Simulador de brigadas
===================================================
Simula los GPS de las 4 brigadas de campo: cada brigada recorre en círculo
3 comunas de su zona y, en cada paso, envía su posición (lat/lon) al webhook
de n8n, como lo haría un GPS real.

Cómo ejecutarlo (PowerShell):
    1. Docker Desktop abierto y los contenedores corriendo
       (verificar con: docker compose ps).
    2. Ir a la carpeta del proyecto:
           cd D:\\Proyectos\\data-automation-geospatial-lab\\14-capstone-geospatial-monitoring
    3. Activar el entorno virtual (en cada ventana nueva de PowerShell):
           .\\.venv\\Scripts\\Activate.ps1
       Debe aparecer (.venv) al inicio de la línea.
    4. Ejecutar en modo prueba (solo imprime, no envía nada):
           python scripts\\simulador_brigadas.py --prueba --pasos 12
       Ejecutar enviando al webhook (cuando exista el workflow del 14.7):
           python scripts\\simulador_brigadas.py --pasos 30
    5. Para detenerlo antes de tiempo: Ctrl + C.

Opciones:
    --prueba        Solo imprime las posiciones; no las envía al webhook.
    --pasos N       Cantidad de pasos a simular. En cada paso, las 4 brigadas avanzan
                    al mismo tiempo y envían su posición.
                    0 = sin límite, hasta Ctrl + C. Por defecto: 12.
    --intervalo S   Segundos de espera entre un paso y el siguiente. Por defecto: 5.

Vocabulario:
    paso   → un avance de cada brigada (todas avanzan al mismo tiempo).
    tramo  → camino de una comuna a la siguiente = 10 pasos.
    vuelta → recorrido completo de la ruta = 3 tramos = 30 pasos.

Credenciales y configuración:
    Se leen del archivo .env en la raíz del repo (POSTGRES_USER,
    POSTGRES_PASSWORD, POSTGRES_DB y, para enviar, N8N_WEBHOOK_URL).
    Ese archivo está en .gitignore: las contraseñas nunca quedan en el
    código ni en GitHub.
"""

# =====================================================================
# 14.6.1 Librerías
# =====================================================================
import argparse                       # argparse: lee las opciones de la línea de comandos (--prueba, --pasos)
import os                             # os.environ: lee variables de entorno (las del .env)
import random                         # random: genera el "ruido" del GPS
import time                           # time.sleep: espera entre un paso y el siguiente
from datetime import datetime         # datetime: fecha y hora de cada posición
from pathlib import Path              # Path: maneja rutas de archivos sin importar el sistema operativo
from zoneinfo import ZoneInfo         # ZoneInfo: zona horaria de Colombia (usa el paquete tzdata)

import psycopg                        # psycopg: driver para conectarse a PostgreSQL
import requests                       # requests: envía peticiones HTTP (el POST al webhook)
from dotenv import load_dotenv        # load_dotenv: carga las variables del archivo .env


# =====================================================================
# 14.6.2 Configuración
# =====================================================================

# Rutas de cada brigada: id_brigada → comunas que recorre, en orden.
# Al llegar a la última comuna, vuelve a la primera (ruta en círculo).
# Los id_brigada son los de plataforma.brigadas (sql/plataforma.sql).
RUTAS = {
    1: [2, 5, 12],    # Brigada Norte:     San José → Ciudadela del Norte → Nuevo Horizonte
    2: [4, 10, 9],    # Brigada Centro:    Estación → La Fuente → Universitaria
    3: [1, 3, 11],    # Brigada Occidente: Atardeceres → Cumanday → La Macarena
    4: [8, 6, 7],     # Brigada Oriente:   Palogrande → Ecoturístico Cerro de Oro → Tesorito
}

PASOS_POR_TRAMO = 10      # posiciones enviadas para ir de una comuna a la siguiente
RUIDO_GRADOS = 0.0002     # desvío máximo al azar (≈ 20 m): un GPS real nunca da una línea perfecta
ZONA = ZoneInfo("America/Bogota")

# Path(__file__).resolve().parents[2] → sube de scripts → 14-capstone... → raíz del repo,
# donde está el .env. Así el script lo encuentra sin importar desde qué carpeta se ejecute.
RAIZ_REPO = Path(__file__).resolve().parents[2]
load_dotenv(RAIZ_REPO / ".env")


# =====================================================================
# 14.6.3 Leer de PostGIS los puntos de las comunas y las brigadas
# =====================================================================
def leer_datos():
    """Devuelve dos diccionarios:
    puntos   → {id_comuna: (lat, lon)}  punto interior de cada comuna, en WGS 84
    brigadas → {id_brigada: nombre}     solo las brigadas activas
    """
    # host 127.0.0.1 y no "localhost": el script corre en la laptop, FUERA de Docker,
    # y en Windows "localhost" puede intentar primero IPv6 y tardar minutos (Proyecto 13).
    with psycopg.connect(
        host="127.0.0.1",
        port=5432,
        dbname=os.environ["POSTGRES_DB"],
        user=os.environ["POSTGRES_USER"],
        password=os.environ["POSTGRES_PASSWORD"],
    ) as conexion:
        # Misma consulta de sql/simulador_brigadas.sql: el punto interior se transforma
        # de EPSG:6256 (metros) a EPSG:4326 (grados), que es lo que envía un GPS.
        filas = conexion.execute("""
            SELECT cc.id_comuna,
                   ST_Y(ST_Transform(cc.geom, 4326)) AS lat,
                   ST_X(ST_Transform(cc.geom, 4326)) AS lon
            FROM monitoreo.comunas_centroides cc
            WHERE cc.tipo = 'punto_interior'
        """).fetchall()
        puntos = {id_comuna: (lat, lon) for id_comuna, lat, lon in filas}

        filas = conexion.execute(
            "SELECT id_brigada, nombre FROM plataforma.brigadas WHERE activa ORDER BY id_brigada"
        ).fetchall()
        brigadas = {id_brigada: nombre for id_brigada, nombre in filas}

    return puntos, brigadas


# =====================================================================
# 14.6.4 Calcular la posición de una brigada en un paso
# =====================================================================
def posicion(ruta, paso, puntos):
    """Devuelve (lat, lon) de la brigada en el paso indicado.

    Ejemplo con ruta [2, 5, 12] y 10 pasos por tramo:
      pasos 0-9   → va de la comuna 2 a la 5
      pasos 10-19 → va de la 5 a la 12
      pasos 20-29 → va de la 12 de vuelta a la 2
      paso 30     → empieza otra vuelta (igual al paso 0)
    """
    pasos_vuelta = PASOS_POR_TRAMO * len(ruta)
    paso = paso % pasos_vuelta                  # % (residuo): reinicia la vuelta al terminarla

    tramo = paso // PASOS_POR_TRAMO              # // (división entera): en qué tramo va
    avance = (paso % PASOS_POR_TRAMO) / PASOS_POR_TRAMO   # 0.0 = inicio del tramo, 0.9 = casi al final

    lat_a, lon_a = puntos[ruta[tramo]]                       # comuna de salida
    lat_b, lon_b = puntos[ruta[(tramo + 1) % len(ruta)]]     # comuna de llegada (después de la última, la primera)

    # Interpolación lineal: avanzar en línea recta una fracción del camino de A a B.
    lat = lat_a + (lat_b - lat_a) * avance
    lon = lon_a + (lon_b - lon_a) * avance

    # Ruido GPS: un desvío al azar de hasta ±20 m en cada eje.
    lat += random.uniform(-RUIDO_GRADOS, RUIDO_GRADOS)
    lon += random.uniform(-RUIDO_GRADOS, RUIDO_GRADOS)

    return round(lat, 6), round(lon, 6)          # 6 decimales ≈ 0.1 m, como un GPS


# =====================================================================
# 14.6.5 Enviar una posición al webhook de n8n
# =====================================================================
def enviar(url, datos):
    """Envía la posición como JSON con un POST. Devuelve un texto con el resultado.
    Si falla, no detiene el simulador: un GPS real sigue intentando con la siguiente posición."""
    try:
        respuesta = requests.post(url, json=datos, timeout=10)   # timeout: no esperar para siempre
        return f"HTTP {respuesta.status_code}"
    except requests.RequestException as error:
        return f"ERROR: {type(error).__name__}"


# =====================================================================
# 14.6.6 Programa principal
# =====================================================================
def main():
    # ----- Opciones de la línea de comandos -----
    parser = argparse.ArgumentParser(description="Simulador de GPS de las brigadas (14.6)")
    parser.add_argument("--prueba", action="store_true", help="solo imprime, no envía al webhook")
    parser.add_argument("--pasos", type=int, default=12, help="pasos a simular (0 = sin límite)")
    parser.add_argument("--intervalo", type=float, default=5, help="segundos entre pasos")
    args = parser.parse_args()

    # ----- Webhook: solo hace falta si se va a enviar -----
    url = os.environ.get("N8N_WEBHOOK_URL")   # .get: devuelve None si no existe, sin fallar
    if not args.prueba and not url:
        raise SystemExit("Falta N8N_WEBHOOK_URL en el .env (o ejecuta con --prueba).")

    # ----- Datos de PostGIS -----
    puntos, brigadas = leer_datos()
    print(f"Comunas leídas: {len(puntos)} | Brigadas activas: {len(brigadas)}")
    print("Modo prueba: solo se imprime." if args.prueba else f"Enviando a: {url}")
    print("Ctrl + C para detener.\n")

    # ----- Pasos: en cada paso, las 4 brigadas avanzan y envían su posición -----
    paso = 0
    try:
        while args.pasos == 0 or paso < args.pasos:
            for id_brigada, nombre in brigadas.items():
                lat, lon = posicion(RUTAS[id_brigada], paso, puntos)

                # Mensaje que enviaría el GPS. La hora va con zona explícita (-05:00),
                # para que PostgreSQL la guarde bien en una columna TIMESTAMPTZ (Proyecto 11).
                datos = {
                    "id_brigada": id_brigada,
                    "lat": lat,
                    "lon": lon,
                    "registrado_en": datetime.now(ZONA).isoformat(timespec="seconds"),
                }

                resultado = "no enviado (prueba)" if args.prueba else enviar(url, datos)
                print(f"Paso {paso + 1:>3} | {nombre:<17} | {lat:.6f}, {lon:.6f} | {resultado}")

            paso += 1
            print()
            if args.pasos == 0 or paso < args.pasos:   # no esperar después del último paso
                time.sleep(args.intervalo)

    except KeyboardInterrupt:                             # Ctrl + C: terminar sin mostrar un error
        print("\nSimulador detenido por el usuario.")

    print(f"Pasos completados: {paso}")


# Solo se ejecuta main() si el archivo se corre directamente (python simulador_brigadas.py),
# no si otro script lo importa.
if __name__ == "__main__":
    main()
