// Importa el cliente de MongoDB y la versión de la API del servidor
const { MongoClient, ServerApiVersion } = require("mongodb");
// Importa la librería para mostrar tablas en la consola
const Table = require("cli-table3");    //SOLO PARA FINES DE DEMOSTRACIÓN
// Carga las variables de entorno desde un archivo .env
require("dotenv").config();

// Obtiene la URI de conexión a MongoDB desde las variables de entorno
const uri = process.env.URI;

// Crea una nueva instancia del cliente de MongoDB con opciones de API
const client = new MongoClient(uri, {
    serverApi: {
        version: ServerApiVersion.v1, // Usa la versión 1 de la API del servidor
        strict: true,                 // Habilita el modo estricto
        deprecationErrors: true,      // Muestra errores por funciones obsoletas
    },
});

/**
 * Conecta a la base de datos MongoDB, obtiene los últimos 20 documentos
 * de la colección "sensor_data" y los muestra en una tabla en la consola.
 */
async function run() {
    try {
        // Intenta conectar al servidor de MongoDB
        await client.connect();
        console.log("Conectado a MongoDB");

        // Selecciona la base de datos "SIEPA"
        const db = client.db("SIEPA");
        // Selecciona la colección "sensor_data"
        const collection = db.collection("sensor_data");

        // Obtiene los últimos 20 documentos ordenados por timestamp descendente
        const docs = await collection.find()
            .sort({ timestamp: -1 }) // Ordena por timestamp descendente
            .limit(20)               // Limita a 20 documentos
            .toArray();              // Convierte el cursor a un arreglo

        // Crea una tabla con encabezados y anchos de columna definidos
        // SOLO PARA FINES DE DEMOSTRACIÓN
        const table = new Table({
            head: ["timestamp", "light", "temperature", "humidity"], // Encabezados
            colWidths: [30, 10, 15, 10],                             // Ancho de columnas
            wordWrap: true,                                          // Ajuste de texto
        });

        // Agrega cada documento como una fila en la tabla
        docs.forEach(doc => {
            table.push([
                doc.timestamp || "",    // Muestra el timestamp o vacío si no existe
                doc.light ?? "",        // Muestra el valor de luz o vacío
                doc.temperature ?? "",  // Muestra la temperatura o vacío
                doc.humidity ?? "",     // Muestra la humedad o vacío
            ]);
        });

        // Muestra la tabla en la consola
        console.log(table.toString());

    } catch (error) {
        // Muestra un mensaje de error si ocurre algún problema
        console.error("Error al consultar la colección:", error);
    } finally {
        // Cierra la conexión al cliente de MongoDB
        await client.close();
    }
}

// Ejecuta la función principal y muestra errores si ocurren
run().catch(console.dir);
