import board
import adafruit_dht
import RPi.GPIO as GPIO
from globals import shared

class Sensors:
    """
    Sensors class for interfacing with environmental sensors such as DHT11.
    Attributes:
        dht: Instance of the DHT11 sensor connected to a specified GPIO pin.
    Methods:
        __init__():
            Initializes the Sensors class and sets up the DHT11 sensor.
        read_sensors():
            Reads temperature and humidity values from the DHT11 sensor and updates
            the shared module's temperature and humidity attributes if valid readings are available.
        print_data():
            Prints the current temperature and humidity values stored in the shared module.
    """
    def __init__(self):
        self.dht = adafruit_dht.DHT11(board.D27)
        # define other sensors here if needed
    
    def read_sensors(self):

        try :
            temperature_c = self.dht.temperature
            humidity = self.dht.humidity
            if temperature_c is None or humidity is None:
                shared.local_error_message = "Error reading sensor data"
                return
            if self.dht.temperature is not None:
                shared.temperature = float(self.dht.temperature)
            if self.dht.humidity is not None:
                shared.humidity = float(self.dht.humidity)
            # Add other sensor readings here if needed
        except RuntimeError as e:
            shared.local_error_message = f"RuntimeError: {e}"

    

    def print_data(self):
        print(f"Temp: {shared.temperature:.1f}")
        print(f"Humidity: {shared.humidity:.1f}%")
        # Print other sensor data here if needed
        