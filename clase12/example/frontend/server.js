// Importa los módulos necesarios
const express = require("express");
const path = require("path");
const { MongoClient, ServerApiVersion } = require("mongodb");
require("dotenv").config(); // Carga variables de entorno desde .env

const app = express(); // Crea una instancia de Express
const PORT = 3000; // Puerto donde correrá el servidor

const uri = process.env.URI; // URI de conexión a MongoDB desde variables de entorno
const client = new MongoClient(uri, {
    serverApi: {
        version: ServerApiVersion.v1,
        strict: true,
        deprecationErrors: true,
    },
});

// Middleware para servir archivos estáticos desde la carpeta 'public'
app.use(express.static("public"));

// Ruta raíz: entrega el archivo index.html ubicado en la carpeta 'views'
app.get("/", (req, res) => {
    res.sendFile(path.join(__dirname, "views", "index.html"));
});

// Ruta API para obtener los últimos 20 registros de la colección 'sensor_data'
app.get("/data", async (req, res) => {
    try {
        await client.connect(); // Conecta al cliente de MongoDB
        const db = client.db("SIEPA"); // Selecciona la base de datos 'SIEPA'
        const collection = db.collection("sensor_data"); // Selecciona la colección 'sensor_data'

        // Obtiene los últimos 20 documentos ordenados por 'timestamp' descendente
        const docs = await collection.find()
            .sort({ timestamp: -1 })
            .limit(20)
            .toArray();

        res.json(docs); // Devuelve los documentos en formato JSON
    } catch (error) {
        console.error("Error al obtener datos:", error);
        res.status(500).json({ error: "Error interno del servidor" }); // Manejo de errores
    }
});

// Inicia el servidor en el puerto especificado
app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
