import time
import threading
from sensors import Sensors
from display import Display

class SIEPA:
    """
    SIEPA is a class representing the main application for a sensor and display system.
    Attributes:
        running (bool): Flag to control the main loop execution.
        intervals (dict): Dictionary storing loop intervals in seconds for different tasks.
        Sensors (Sensors): Instance of the Sensors class for reading sensor data.
        Display (Display): Instance of the Display class for managing display output.
    Methods:
        __init__():
            Initializes the SIEPA system, sets up intervals, sensors, and display, and shows an initialization message.
        run_tasks():
            Reads sensor data, prints it, and updates the display.
        mqtt_tasks():
            Placeholder for MQTT-related tasks (to be implemented).
        main_loop():
            Starts the MQTT tasks in a separate thread and runs the main application loop, executing tasks at specified intervals.
            Handles graceful shutdown on KeyboardInterrupt.
    """
    def __init__(self):
        # Flag to control the main loop
        self.running = True
        # Dictionary to store loop intervals (in seconds)
        self.intervals = {
            "principal": 0.2,   # Principal loop interval in seconds
            "MQTT": 1,          # MQTT loop interval in seconds
        }
        # Initialize Sensors and Display objects
        self.Sensors = Sensors()
        self.Display = Display()
        # Show initialization message on the display
        self.Display.display_message("Initializing SIEPA...")

    def run_tasks(self):
        # Read sensor data, print it, and update the display
        self.Sensors.read_sensors()
        self.Sensors.print_data()
        self.Display.update()
        
    def mqtt_tasks(self):
        # Placeholder for MQTT-related tasks (to be implemented)
        pass
    
    def main_loop(self):
        # Main loop of the application
        mqtt_thread = None
        try:
            # Start MQTT tasks in a separate thread
            mqtt_thread = threading.Thread(target=self.mqtt_tasks)
            mqtt_thread.start()

            # Main loop: run tasks at the specified interval
            while self.running:
                self.run_tasks()
                time.sleep(self.intervals["principal"]) # 0.1s
                
        except KeyboardInterrupt:
            # Handle program interruption (Ctrl+C)
            print("Exiting program")
            self.running = False
            if mqtt_thread is not None:
                mqtt_thread.join()

if __name__ == "__main__":
    # Entry point: create SIEPA instance and start main loop
    siepa = SIEPA()
    siepa.main_loop()
    print("Program terminated gracefully.")
