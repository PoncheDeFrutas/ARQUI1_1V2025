import time
from rpi_lcd import LCD
from globals import shared

class Display:
    """
    Display class for managing an LCD display to show sensor data and messages.
    Attributes:
        lcd: Instance of the LCD class for controlling the display.
        enable (bool): Indicates if the display is enabled for updates.
        last_t (float): Timestamp of the last display update.
        threshold_data (float): Minimum interval (in seconds) between data updates.
        threshold_message (float): Duration (in seconds) to show a message before returning to data display.
    Methods:
        __init__():
            Initializes the Display object, sets up the LCD, and configures thresholds.
        display_data():
            Clears the display and shows the latest temperature and humidity readings.
        display_message(message):
            Clears the display and shows a custom message, disabling further updates for a set duration.
        update():
            Manages display updates based on timing thresholds and error messages.
            Shows error messages with priority, otherwise updates sensor data.
    """
    def __init__ (self):
        self.lcd = LCD(0x27, 1, 16, 2, True)
        self.enable = True
        self.last_t = 0
        self.threshold_data = 0.5
        self.threshold_message = 5.0
        self.lcd.clear()
        self.lcd.backlight(self.enable)

    
    def display_data(self):
        self.lcd.clear()
        self.lcd.text(f'Temp: {shared.temperature:.1f}C', 1)
        self.lcd.text(f'Hum: {shared.humidity:.1f}%', 2)
        self.last_t = time.time()
        # add other sensor data here if needed
    
    def display_message(self, message):
        self.lcd.clear()
        self.lcd.text(message, 1)
        self.enable = False  # Disable display after showing message
        self.last_t = time.time()

    def update(self):
        if not self.enable:
            if time.time() - self.last_t > self.threshold_message:
                self.enable = True
            else:
                return
        else:
            if not (time.time() - self.last_t > self.threshold_data):
                return
        

        if shared.local_error_message:
            self.display_message(shared.local_error_message)
            shared.local_error_message = ""
        else:
            self.display_data()