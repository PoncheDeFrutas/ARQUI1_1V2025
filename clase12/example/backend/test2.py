import os
"""
This script simulates sensor data generation and periodically inserts the data into a MongoDB collection.
Functionality:
- Loads environment variables from a .env file to obtain the MongoDB URI.
- Connects to a MongoDB database ('SIEPA') and selects the 'sensor_data' collection.
- Every 30 seconds, generates simulated sensor readings for light (lux), temperature (°C), and humidity (%).
- Each data entry includes a UTC timestamp in ISO format.
- Inserts the generated data into the MongoDB collection and prints the inserted document's ID.
- Runs indefinitely, with a short sleep interval to minimize CPU usage.
Requirements:
- Python packages: os, time, random, datetime, dotenv, pymongo
- A .env file containing the MongoDB URI as 'URI'
"""
import time
import random
from datetime import datetime, timezone
from dotenv import load_dotenv
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi

# Cargar variables de entorno desde un archivo .env
load_dotenv()
uri = os.getenv("URI")  # Obtener la URI de MongoDB desde las variables de entorno

# Crear cliente de MongoDB usando la URI y la API de servidor versión 1
client = MongoClient(uri, server_api=ServerApi('1'))
db = client["SIEPA"]  # Seleccionar la base de datos 'SIEPA'
collection = db["sensor_data"]  # Seleccionar la colección 'sensor_data'

# Guardar el tiempo de inicio como referencia
start_time = time.time()

# Bucle infinito que ejecuta el proceso cada 30 segundos
while True:
    current_time = time.time()  # Obtener el tiempo actual
    
    if current_time - start_time >= 30:
        # Generar datos simulados de sensores
        data = {
            "timestamp": datetime.utcnow().replace(tzinfo=timezone.utc),
            "light": random.randint(100, 1000),            # Valor de luz aleatorio (lux)
            "temperature": round(random.uniform(15, 35), 2),  # Temperatura aleatoria (°C)
            "humidity": round(random.uniform(30, 90), 2)      # Humedad aleatoria (%)
        }

        # Insertar los datos generados en la colección de MongoDB
        result = collection.insert_one(data)
        print("Data inserted with ID:", result.inserted_id)  # Mostrar el ID del documento insertado

        # Actualizar el tiempo de referencia para el siguiente ciclo
        start_time = current_time

    # Pausa corta para evitar uso excesivo de CPU
    time.sleep(0.1)
