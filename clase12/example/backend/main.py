import os
"""
This script connects to a MongoDB database using credentials stored in environment variables.

Steps performed:
1. Loads environment variables from a .env file using `dotenv`.
2. Retrieves the MongoDB URI from the environment variable "URI".
3. Creates a MongoDB client using the provided URI and sets the server API version to 1.
4. Prints a message indicating the client was created successfully.
5. Attempts to ping the MongoDB server to verify the connection:
    - If successful, prints a confirmation message.
    - If an error occurs, prints the exception.

Dependencies:
- python-dotenv: For loading environment variables from a .env file.
- pymongo: For connecting and interacting with MongoDB.

Usage:
Ensure a .env file exists with a valid "URI" variable before running this script.
"""
from dotenv import load_dotenv

from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi

# Carga las variables de entorno desde el archivo .env
load_dotenv()

# Obtiene el URI de MongoDB desde la variable de entorno "URI"
uri = os.getenv("URI")

# Crea un nuevo cliente de MongoDB usando el URI y especifica la versión de la API del servidor
client = MongoClient(uri, server_api=ServerApi('1'))

print("MongoDB client created successfully.")

# Intenta hacer ping al servidor para verificar la conexión
try:
    client.admin.command('ping')  # Comando 'ping' para comprobar la conectividad
    print("Pinged your deployment. You successfully connected to MongoDB!")
except Exception as e:
    # Si ocurre un error, imprime la excepción
    print(e)