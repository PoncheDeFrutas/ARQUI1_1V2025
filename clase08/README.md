# Interactividad del Dashboard Web + Control de Actuadores

## Visión General
Este módulo establece una comunicación bidireccional completa entre:
1. **Dashboard Web**: Interfaz de control visual en el frontend
2. **Dispositivos IoT**: Actuadores físicos conectados a la Raspberry Pi

## Objetivos Clave
- Implementar **tópicos MQTT de control** (`grupo#/actuadores/+`)
- Desarrollar **componentes UI interactivos** (botones, sliders)
- Garantizar **sincronización en tiempo real** entre:
  - Estado físico de actuadores
  - Representación visual en dashboard

## Arquitectura Propuesta
[Dashboard Web] ←MQTT→ [Broker] ←MQTT→ [Raspberry Pi]

(Node.js/Express) (mqttx) (Python/GPIO)


## Prerrequisitos
- Broker MQTT operativo
- Dashboard base funcionando (de módulos anteriores)
- Actuadores conectados (LEDs, ventiladores, etc.)
- Librerías instaladas:
  - Frontend: `mqtt.js`, `chart.js`
  - Backend: `mqtt`
  - Raspberry Pi: `paho-mqtt`, `RPi.GPIO`

# Dashboard MQTT Simple + Control de GPIO con Python

## 1. Estructura del Backend (Python)

## Cliente MQTT para Control de LED en Raspberry Pi

Este código implementa un cliente MQTT en Python que controla un LED conectado a una Raspberry Pi mediante mensajes MQTT.

---

## Estructura del Código

### 1. Importación de Librerías

```python
import time
import random
import RPi.GPIO as GPIO
import paho.mqtt.client as mqtt
```

* `time`: Para manejar pausas y tiempos
* `random`: Para generar un ID de cliente aleatorio
* `RPi.GPIO`: Para controlar los pines GPIO de la Raspberry Pi
* `paho.mqtt.client`: Para la comunicación MQTT

---

### 2. Configuración GPIO

```python
LED_PIN = 11
GPIO.setmode(GPIO.BOARD)
GPIO.setup(LED_PIN, GPIO.OUT, initial=GPIO.LOW)
```

* Configura el pin 11 (físico) como salida para controlar un LED.
* Inicializa el LED en estado apagado (`LOW`).

---

### 3. Configuración MQTT

```python
broker = 'broker.emqx.io'
port = 1883
topic = "python/mqtt/Arqui1"
client_id = f'python-mqtt-{random.randint(0, 1000)}'
```

* **Broker MQTT**: `broker.emqx.io` (público)
* **Puerto**: `1883`
* **Tópico**: `python/mqtt/Arqui1`
* **Client ID**: Generado aleatoriamente para cada ejecución

---

### 4. Función `connect_mqtt()`

```python
def connect_mqtt() -> mqtt.Client:
    def on_connect(client, userdata, flags, rc):
        if rc == 0:
            print("Connected to MQTT Broker!")
        else:
            print(f"Failed to connect, return code {rc}\n")
    
    client = mqtt.Client(client_id=client_id)
    client.on_connect = on_connect
    client.connect(broker, port)
    return client
```

* Crea y configura el cliente MQTT
* Define callback para manejar eventos de conexión
* Conecta al broker
* Devuelve el cliente conectado

---

### 5. Función `subscribe()`

```python
def subscribe(client: mqtt.Client):
    def on_message(client, userdata, msg):
        print(f"Received `{msg.payload.decode()}` from `{msg.topic}` topic")
        if msg.payload.decode() == "ON":
            GPIO.output(LED_PIN, GPIO.HIGH)  # Enciende el LED
        elif msg.payload.decode() == "OFF":
            GPIO.output(LED_PIN, GPIO.LOW)   # Apaga el LED
    
    client.subscribe(topic)
    client.on_message = on_message
```

* Se suscribe al tópico configurado
* Callback para mensajes entrantes:

  * Si es `"ON"`, enciende el LED
  * Si es `"OFF"`, apaga el LED

---

### 6. Función principal `run()`

```python
def run():
    client = connect_mqtt()
    subscribe(client)
    client.loop_start()  # Inicia el loop MQTT
    
    try:
        while True:
            time.sleep(1)  # Mantiene el programa ejecutándose
    except KeyboardInterrupt:
        print("Exiting program")
    finally:
        GPIO.cleanup()       # Limpia configuración GPIO
        client.loop_stop()   # Detiene el loop MQTT
        client.disconnect()  # Desconecta del broker
```

* Maneja la ejecución principal
* Gestiona interrupciones (Ctrl+C)
* Limpieza segura de recursos

---

### 7. Ejecución Principal

```python
if __name__ == "__main__":
    run()
```

---

## Flujo de Operación

### Inicialización

* Configura GPIO
* Genera un ID único de cliente
* Establece parámetros de conexión MQTT

### Conexión

* Se conecta al broker público
* Callback para detectar si fue exitoso

### Suscripción

* Se suscribe al tópico MQTT
* Callback para recibir comandos

### Control del LED

* Espera mensajes `"ON"` o `"OFF"`
* Activa o desactiva el LED

### Finalización

* Al presionar Ctrl+C:

  * Limpia GPIO
  * Detiene el bucle MQTT
  * Se desconecta del broker

---

## Características Clave

* **Control físico**: Maneja un LED real en la Raspberry Pi.
* **MQTT asíncrono**: Usa `loop_start()` para escuchar mensajes en segundo plano.
* **Manejo seguro de recursos**: Uso de `try/except/finally` para cerrar correctamente.
* **ID único**: Se genera en cada ejecución.
* **Callbacks**: Gestión de eventos MQTT con funciones personalizadas.

---

# 2. Estructura del Frontend (HTML/JavaScript)
## Descripción del Archivo Frontend JavaScript con WebSocket

Este archivo es el frontend JavaScript que maneja la interfaz web y la comunicación con el servidor WebSocket. A continuación se analiza función por función:

## 1. Conexión WebSocket

```javascript
const ws = new WebSocket('ws://localhost:8080');
```

* Crea una nueva conexión WebSocket al servidor local en el puerto 8080.
* El protocolo `ws://` es para conexiones WebSocket no cifradas (equivalente a HTTP).
* Para producción debería usarse `wss://` (WebSocket seguro, equivalente a HTTPS).

## 2. Event Handlers WebSocket

### `onopen`

```javascript
ws.onopen = () => {
    console.log('Conectado al servidor WebSocket');
};
```

* Se ejecuta cuando la conexión WebSocket se establece exitosamente.
* Muestra un mensaje en consola para confirmar la conexión.

### `onmessage`

```javascript
ws.onmessage = (event) => {
    const data = JSON.parse(event.data);
    updateUI({
        destinationName: data.topic,
        payloadString: data.payload
    });
};
```

* Se dispara cada vez que llega un mensaje del servidor WebSocket.
* `event.data` contiene el mensaje (en formato JSON string).
* Se parsea a objeto JavaScript con `JSON.parse()`.
* Llama a `updateUI()` con los datos recibidos.

## 3. Función `toggleLED(elementId)`

```javascript
function toggleLED(elementId) {
    const button = document.getElementById(elementId);
    const newState = button.textContent.includes("ON") ? "OFF" : "ON";

    // Enviar estado al servidor WebSocket
    ws.send(JSON.stringify({
        topic: "python/mqtt/Arqui1",
        payload: newState
    }));

    // Actualizar UI
    button.textContent = `LED 1 ${newState}`;
    button.className = newState === "ON" ? "on" : "off";
}
```

### Flujo de ejecución:

* Obtiene el elemento del botón usando el ID proporcionado.
* Determina el nuevo estado:

  * Si el texto actual incluye "ON", cambia a "OFF".
  * Si no, cambia a "ON".
* Envía el nuevo estado al servidor WebSocket:

  ```json
  {
      "topic": "python/mqtt/Arqui1",
      "payload": "ON" // o "OFF"
  }
  ```
* Actualiza inmediatamente la interfaz:

  * Cambia el texto del botón (ej. "LED 1 ON").
  * Cambia la clase CSS para actualizar el color.

## 4. Función `updateUI(message)`

```javascript
function updateUI(message) {
    const element = document.getElementById('led1');
    if(element) {
        element.textContent = `LED 1 ${message.payloadString}`;
        element.className = message.payloadString === "ON" ? "on" : "off";
    }
}
```

### Propósito:

* Sincroniza la interfaz con el estado actual del LED.
* Se llama cuando llegan actualizaciones del servidor (vía WebSocket).

### Parámetros:

* `message`: Objeto con:

  * `destinationName`: Tópico MQTT (no usado actualmente).
  * `payloadString`: Estado ("ON" o "OFF").

### Comportamiento:

* Obtiene el elemento del botón LED.
* Si existe:

  * Actualiza el texto para mostrar el estado actual.
  * Cambia la clase CSS para reflejar el estado visualmente:

    * `"on"` → Fondo verde
    * `"off"` → Fondo rojo

## Flujo Completo de Comunicación

1. Usuario hace clic en el botón:

   * Se ejecuta `toggleLED('led1')` (desde el HTML `onclick`).
   * Determina el nuevo estado opuesto al actual.
   * Envía el comando al servidor vía WebSocket.
   * Actualiza la UI localmente (optimistic update).

2. Llega actualización del servidor:

   * Cuando el estado cambia desde otro cliente o se confirma la acción.
   * El servidor envía mensaje WebSocket.
   * Se ejecuta `onmessage`.
   * Llama a `updateUI()` para sincronizar la interfaz.

## Consideraciones Importantes

* **Actualización optimista:**

  * La UI se actualiza inmediatamente al hacer clic, sin esperar confirmación.
  * Si hay error de conexión, podría quedar desincronizada.

* **Formato de mensajes:**

  * Todos los mensajes WebSocket son JSON strings.
  * Estructura consistente: `{topic, payload}`.

* **Manejo de errores:**

  * Actualmente no hay manejo de errores para conexiones fallidas.
  * En producción debería agregarse `onerror` y `onclose`.

* **Escalabilidad:**

  * El código está preparado para múltiples LEDs (usa `elementId`).
  * Podría extenderse fácilmente para más controles.

# Servidor Node.js: HTTP, WebSocket y MQTT

Este archivo es el corazón del sistema, actuando como:

* Servidor HTTP para la interfaz web
* Servidor WebSocket para comunicación en tiempo real
* Puente entre WebSocket y MQTT

## 1. Importación de Módulos

```javascript
const http = require('http');
const fs = require('fs');
const path = require('path');
const WebSocket = require('ws');
const mqtt = require("mqtt");
```

* `http`: Para crear el servidor web
* `fs`: Para leer archivos del sistema (HTML, JS)
* `path`: Para manejar rutas de archivos
* `ws`: Para servidor WebSocket
* `mqtt`: Para conexión con el broker MQTT

## 2. Configuración del Cliente MQTT

```javascript
const mqttClient = mqtt.connect("mqtt://broker.emqx.io:1883", {
    clientId: `mqtt_${Math.random().toString(16).slice(3)}`,
    username: "emqx",
    password: "public"
});
```

* Conecta al broker público EMQX
* Genera un `clientId` aleatorio
* Usa credenciales públicas

## 3. Servidor HTTP

```javascript
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
```

* Sirve `index.html` para `/`
* Sirve archivos JS y HTML según la ruta
* Maneja tipos MIME
* Devuelve 404 si no se encuentra el archivo

## 4. Servidor WebSocket

```javascript
const wss = new WebSocket.Server({ server });

wss.on('connection', (ws) => {
    console.log('Cliente WebSocket conectado');

    mqttClient.on('message', (topic, message) => {
        ws.send(JSON.stringify({
            topic: topic,
            payload: message.toString()
        }));
    });

    mqttClient.subscribe("python/mqtt/Arqui1");

    ws.on('message', (message) => {
        const data = JSON.parse(message);
        mqttClient.publish(data.topic, data.payload);
    });
});
```

* Por cada conexión WS:

  * Escucha mensajes MQTT y los reenvía al cliente
  * Suscribe al tópico MQTT
  * Escucha mensajes del navegador y los publica en MQTT

## 5. Eventos MQTT

```javascript
mqttClient.on('connect', () => {
    console.log('Conectado al broker MQTT');
});
```

* Confirma conexión exitosa con el broker

## 6. Inicio del Servidor

```javascript
server.listen(8080, () => {
    console.log('Servidor corriendo en http://localhost:8080');
});
```

* Inicia servidor HTTP en el puerto 8080
* WS comparte el mismo puerto

## Diagrama de Flujo de Mensajes

### Navegador → Raspberry Pi

```text
Navegador → WS → Node.js → MQTT → Raspberry Pi
```

### Raspberry Pi → Navegador

```text
Raspberry Pi → MQTT → Node.js → WS → Navegador
```

## Funciones Clave

### Puente WebSocket-MQTT

#### WebSocket a MQTT:

```javascript
ws.on('message', (message) => {
    const data = JSON.parse(message);
    mqttClient.publish(data.topic, data.payload);
});
```

#### MQTT a WebSocket:

```javascript
mqttClient.on('message', (topic, message) => {
    ws.send(JSON.stringify({
        topic: topic,
        payload: message.toString()
    }));
});
```

## Servidor de Archivos Estáticos

* Maneja rutas dinámicas
* Detecta tipos de contenido
* Provee fallback (404)

## Consideraciones de Implementación

### Gestión de Conexiones

* No lleva registro de múltiples clientes
* En producción debe escalar para manejar varios clientes

### Seguridad

* No hay autenticación WS
* MQTT usa credenciales públicas

### Escalabilidad

* El puente es 1:1 (cada cliente crea su suscripción)
* Puede optimizarse usando una sola suscripción global

### Manejo de Errores

* No se gestionan desconexiones MQTT
* No hay reintentos automáticos
