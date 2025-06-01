const http = require('http');
const fs = require('fs');
const path = require('path');
const WebSocket = require('ws');
const mqtt = require("mqtt");

// MQTT Client
const mqttClient = mqtt.connect("mqtt://broker.emqx.io:1883", {
    clientId: `mqtt_${Math.random().toString(16).slice(3)}`,
    username: "emqx",
    password: "public"
});

// This code sets up an HTTP server that serves static files and integrates with MQTT and WebSocket for real-time communication.
/**
 * Creates an HTTP server that serves static files based on the request URL.
 * If the root URL ('/') is requested, it serves 'index.html'.
 * For other URLs, it attempts to serve the corresponding file from the current directory.
 * Responds with a 404 status and message if the file is not found.
 * Sets the 'Content-Type' header based on the file extension (supports HTML and JS).
 *
 * @param {import('http').IncomingMessage} req - The HTTP request object.
 * @param {import('http').ServerResponse} res - The HTTP response object.
 */
const server = http.createServer((req, res) => {
    const filePath = req.url === '/' ? './index.html' : '.' + req.url;
    
    fs.readFile(filePath, (err, content) => {
        if (err) {
            res.writeHead(404);
            res.end('Archivo no encontrado');
            return;
        }
        
        let contentType = 'text/html';
        if (filePath.endsWith('.js')) contentType = 'text/javascript';
        
        res.writeHead(200, { 'Content-Type': contentType });
        res.end(content);
    });
});

// WebSocket Server
const wss = new WebSocket.Server({ server });

wss.on('connection', (ws) => {
    console.log('Cliente WebSocket conectado');
    
    // Create a listener for MQTT messages
    mqttClient.on('message', (topic, message) => {
        ws.send(JSON.stringify({
            topic: topic,
            payload: message.toString()
        }));
    });
    
    // Subscribe to the MQTT topic
    mqttClient.subscribe("python/mqtt/Arqui1");
    
    // Handle incoming messages from WebSocket clients
    ws.on('message', (message) => {
        const data = JSON.parse(message);
        mqttClient.publish(data.topic, data.payload);
    });
});

mqttClient.on('connect', () => {
    console.log('Conectado al broker MQTT');
});

server.listen(8080, () => {
    console.log('Servidor corriendo en http://localhost:8080');
});