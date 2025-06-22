import os
from dotenv import load_dotenv
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
from tabulate import tabulate

# Cargar .env
load_dotenv()
uri = os.getenv("URI")

# Conexión a MongoDB Atlas
client = MongoClient(uri, server_api=ServerApi('1'))
db = client["SIEPA"]
collection = db["sensor_data"]

# Obtener los últimos 30 documentos ordenados por timestamp descendente
cursor = collection.find().sort("timestamp", -1).limit(30)

# Convertir a lista de diccionarios
data = list(cursor)

# Preparar datos para tabular
headers = ["timestamp", "light", "temperature", "humidity"]
table = []

for doc in data:
    row = [
        doc.get("timestamp", ""),
        doc.get("light", ""),
        doc.get("temperature", ""),
        doc.get("humidity", ""),
    ]
    table.append(row)

# Mostrar tabla en consola
print(tabulate(table, headers=headers, tablefmt="fancy_grid"))
