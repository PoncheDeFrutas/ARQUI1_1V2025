import os
from dotenv import load_dotenv

from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi

load_dotenv()

uri = os.getenv("URI")

# Create a new client and connect to the server
client = MongoClient(uri, server_api=ServerApi('1'))


db = client["SIEPA"]
collection = db["sensor_data"]

data = {
    "timestamp": "2023-10-01T12:00:00Z",
    "light": 300,
    "temperature": 22.5,
    "humidity": 45.0,
}

result = collection.insert_one(data)

print("Data inserted with ID:", result.inserted_id)