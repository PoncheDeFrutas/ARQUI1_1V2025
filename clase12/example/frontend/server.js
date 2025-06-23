const express = require("express");
const path = require("path");
const { MongoClient, ServerApiVersion } = require("mongodb");
require("dotenv").config();

const app = express();
const PORT = 3000;

const uri = process.env.URI;
const client = new MongoClient(uri, {
    serverApi: {
        version: ServerApiVersion.v1,
        strict: true,
        deprecationErrors: true,
    },
});

// Middleware para servir archivos estáticos
app.use(express.static("public"));

// Ruta raíz: entrega la página
app.get("/", (req, res) => {
    res.sendFile(path.join(__dirname, "views", "index.html"));
});

// API para obtener los últimos 20 registros
app.get("/data", async (req, res) => {
    try {
        await client.connect();
        const db = client.db("SIEPA");
        const collection = db.collection("sensor_data");

        const docs = await collection.find()
            .sort({ timestamp: -1 })
            .limit(20)
            .toArray();

        res.json(docs);
    } catch (error) {
        console.error("Error al obtener datos:", error);
        res.status(500).json({ error: "Error interno del servidor" });
    }
});

app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});
