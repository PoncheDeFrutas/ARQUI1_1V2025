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
