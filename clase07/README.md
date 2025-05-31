# Introducción a NodeJs para IoT

## Objetivos de Aprendizaje
1. **Integración MQTT con Node.js**: Creación de clientes MQTT usando la librería `mqtt.js`
3. **Visualización de Datos**: Construcción de interfaz web para monitoreo en tiempo real

## Alcance Tecnológico
- **Protocolo MQTT** en entornos Node.js
- **Frontend Básico** para visualización (HTML/CSS/JS)

## Requisitos Previos
- Broker MQTT funcionando (MQTTX)
- Node.js instalado (v16+ recomendado)
- Conocimientos básicos de JavaScript


# Instalación de Nodejs
```bash
# Descarga e instala nvm:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash

# en lugar de reiniciar la shell
\. "$HOME/.nvm/nvm.sh"

# Descarga e instala Node.js:
nvm install 22

# Verifica la versión de Node.js:
node -v # Debería mostrar "v22.16.0".
nvm current # Debería mostrar "v22.16.0".

# Descarga e instala pnpm:
corepack enable pnpm

# Verifica versión de pnpm:
pnpm -v
```

# Creación del Proyecto Utilizando pnpn con vite
```bash
pnpm create vite . --template react-ts
pnpm install
pnpm approve_builds
pnpm run dev
````

# instalación de dependencias
```bash
pnpm add mqtt
pnpm add recharts
```


# Ejemplo de Cliente MQTT en Node.js
```javascript
const mqtt = require("mqtt");

const host = "broker.emqx.io";
const port = "1883";
const clientId = `mqtt_${Math.random().toString(16).slice(3)}`;

const connectUrl = `mqtt://${host}:${port}`;

/**
 * MQTT client instance configured to connect to the specified broker.
 *
 * @type {import('mqtt').MqttClient}
 * @property {string} clientId - Unique identifier for the MQTT client.
 * @property {boolean} clean - If true, starts a clean session.
 * @property {number} connectTimeout - Time in milliseconds to wait before timing out the connection.
 * @property {string} username - Username for broker authentication.
 * @property {string} password - Password for broker authentication.
 * @property {number} reconnectPeriod - Interval in milliseconds between reconnection attempts.
 */
const client = mqtt.connect(connectUrl, {
    clientId,
    clean: true,
    connectTimeout: 4000,
    username: "emqx",
    password: "public",
    reconnectPeriod: 1000,
});

const topic = "python/mqtt/Arqui1";

client.on("connect", () => {
    console.log("Connected");

    client.subscribe([topic], () => {
        console.log(`Subscribe to topic '${topic}'`);
        client.publish(
            topic,
            "nodejs mqtt test",
            { qos: 0, retain: false },
            (error) => {
                if (error) {
                    console.error(error);
                }
            }
        );
    });
});

client.on("message", (topic, payload) => {
    console.log("Received Message:", topic, payload.toString());
});

```

# Cliente MQTT en Node.js: Explicado paso a paso

Este documento describe y explica detalladamente un cliente MQTT implementado en Node.js. El cliente se conecta a un broker público, se suscribe a un tópico, publica un mensaje y escucha mensajes entrantes.

---

## 1. Importación de la librería MQTT

```javascript
const mqtt = require("mqtt");
```

* Se importa el paquete `mqtt`, necesario para establecer comunicación con el broker MQTT.

---

## 2. Configuración de conexión

```javascript
const host = "broker.emqx.io";
const port = "1883";
const clientId = `mqtt_${Math.random().toString(16).slice(3)}`;
const connectUrl = `mqtt://${host}:${port}`;
```

* **host**: Broker MQTT público EMQX.
* **port**: Puerto estándar MQTT (1883).
* **clientId**: Identificador único para cada cliente generado aleatoriamente.
* **connectUrl**: URL completa de conexión.

---

## 3. Opciones de conexión

```javascript
const client = mqtt.connect(connectUrl, {
    clientId,
    clean: true,
    connectTimeout: 4000,
    username: "emqx",
    password: "public",
    reconnectPeriod: 1000,
});
```

* **clean**: Sesiones limpias, sin mensajes guardados.
* **connectTimeout**: Tiempo de espera de 4 segundos para la conexión.
* **username / password**: Credenciales para autenticación.
* **reconnectPeriod**: Reintento de conexión cada 1 segundo.

---

## 4. Definición del tópico

```javascript
const topic = "python/mqtt/Arqui1";
```

* Tópico al que se suscribirá y publicará el cliente.

---

## 5. Evento `connect`

```javascript
client.on("connect", () => {
    console.log("Connected");
    client.subscribe([topic], () => {
        console.log(`Subscribe to topic '${topic}'`);
        client.publish(
            topic,
            "nodejs mqtt test",
            { qos: 0, retain: false },
            (error) => {
                if (error) {
                    console.error(error);
                }
            }
        );
    });
});
```

* Al conectar:

  * Se suscribe al tópico.
  * Publica un mensaje de prueba.
  * Se usa `QoS 0` (al menos una vez) y `retain: false` (no se guarda el mensaje).

---

## 6. Evento `message`

```javascript
client.on("message", (topic, payload) => {
    console.log("Received Message:", topic, payload.toString());
});
```

* Escucha mensajes entrantes del tópico suscrito.
* Imprime el nombre del tópico y el contenido recibido.

---

## Flujo de Ejecución

1. El cliente se conecta al broker EMQX.
2. Se suscribe al tópico `python/mqtt/Arqui1`.
3. Publica un mensaje de prueba en el mismo tópico.
4. Escucha mensajes entrantes y los imprime en consola.

---

## Características Clave

* **Broker público**: `broker.emqx.io` (gratis para pruebas).
* **Reconexión automática**: Intenta reconectar cada segundo si se pierde la conexión.
* **Identificador aleatorio**: clientId único en cada ejecución.
* **QoS 0**: Mínimo esfuerzo, sin confirmación.
* **No retención de mensajes**: No guarda mensajes para nuevos clientes.

---
