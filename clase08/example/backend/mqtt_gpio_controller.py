import time
import random
import RPi.GPIO as GPIO
import paho.mqtt.client as mqtt

# GPIO setup
LED_PIN = 11
GPIO.setmode(GPIO.BOARD)
GPIO.setup(LED_PIN, GPIO.OUT, initial=GPIO.LOW)

broker = 'broker.emqx.io'
port = 1883
topic = "python/mqtt/Arqui1"
# Generate a unique client ID
client_id = f'python-mqtt-{random.randint(0, 1000)}'

def connect_mqtt() -> mqtt.Client:
    """
    Connects to the MQTT broker and returns the client instance.
    
    Returns:
        mqtt.Client: The connected MQTT client instance.
    """
    def on_connect(client, userdata, flags, rc):
        if rc == 0:
            print("Connected to MQTT Broker!")
        else:
            print(f"Failed to connect, return code {rc}\n")
    
    client = mqtt.Client(client_id=client_id)
    client.on_connect = on_connect
    client.connect(broker, port)
    return client

def subscribe(client: mqtt.Client):
    """
    Subscribes to the specified MQTT topic and sets up a callback for message reception.
    
    Args:
        client (mqtt.Client): The MQTT client instance to subscribe with.
    """
    def on_message(client, userdata, msg):
        print(f"Received `{msg.payload.decode()}` from `{msg.topic}` topic")
        if msg.payload.decode() == "ON":
            GPIO.output(LED_PIN, GPIO.HIGH)  # Turn on the LED
        elif msg.payload.decode() == "OFF":
            GPIO.output(LED_PIN, GPIO.LOW)   # Turn off the LED
    
    client.subscribe(topic)
    client.on_message = on_message

def run():
    """
    Main function to run the MQTT client, subscribe to the topic, and start the loop.
    """
    client = connect_mqtt()
    subscribe(client)
    client.loop_start()  # Start the loop to process network traffic and callbacks
    
    try:
        while True:
            time.sleep(1)  # Keep the script running
    except KeyboardInterrupt:
        print("Exiting program")
    finally:
        GPIO.cleanup()  # Clean up GPIO settings
        client.loop_stop()  # Stop the MQTT loop
        client.disconnect()  # Disconnect from the MQTT broker

if __name__ == "__main__":
    run()