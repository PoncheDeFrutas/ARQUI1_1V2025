import time
import random

from paho.mqtt import client as mqtt_client

broker = 'broker.emqx.io'
port = 1883
topic = "python/mqtt/Arqui1"

# Generate a unique client ID
client_id = f'python-mqtt-{random.randint(0, 1000)}'
# username = 'emqx'
# password = 'public'

def connect_mqtt():
    def on_connect(client, userdata, flags, rc):
        if rc == 0:
            print("Connected to MQTT Broker!")
        else:
            print(f"Failed to connect, return code {rc}\n")
    
    client = mqtt_client.Client(client_id=client_id)
    # client.username_pw_set(username, password)
    client.on_connect = on_connect
    client.connect(broker, port)
    return client

def publish(client):
    """
    Publishes a series of messages to a specified MQTT topic using the provided client.
    Args:
        client: The MQTT client instance used to publish messages.
    Behavior:
        - Sends a message every 1.5 seconds to the topic specified by the global variable `topic`.
        - Each message is of the format "Message {msg_count}" where msg_count is incremented with each message.
        - Prints a confirmation if the message is sent successfully, or an error message otherwise.
        - Stops after sending 11 messages (from msg_count 0 to 10), printing a stopping message.
    """
    msg_count = 0
    while True:
        time.sleep(1.5)
        msg = f"Message {msg_count}"
        result = client.publish(topic, msg)
        
        status = result[0]
        if status == 0:
            print(f"Send `{msg}` to topic `{topic}`")
        else:
            print(f"Failed to send message to topic {topic}")
        
        msg_count += 1

        if msg_count > 10:
            print("Stopping after 10 messages.")
            break

def run():
    client = connect_mqtt()
    client.loop_start()  # Start the loop to process network traffic and callbacks
    publish(client)
    client.loop_stop()  # Stop the loop when done

if __name__ == '__main__':
    run()
    print("Finished publishing messages.")