# Example: Read voltage from channel 3 of an ADS1115 ADC using CircuitPython
"""
This script reads the voltage from channel 3 (P3) of an ADS1115 analog-to-digital converter (ADC)
using CircuitPython libraries. It continuously prints the measured voltage and raw ADC value to the
console once per second.
Modules:
    - time: Provides time-related functions for delays.
    - board: Provides board-specific pin definitions.
    - busio: Provides I2C bus implementation.
    - adafruit_ads1x15.ads1115: Library for interfacing with the ADS1115 ADC.
    - adafruit_ads1x15.analog_in: Provides AnalogIn class for reading analog values.
Usage:
    - The script initializes the I2C bus and the ADS1115 ADC.
    - It sets up channel 3 (P3) as a single-ended analog input.
    - In a loop, it reads and prints the voltage and raw ADC value from channel 3 every second.
    - The loop can be interrupted with a KeyboardInterrupt (Ctrl+C), which will print a message and exit gracefully.
"""

import time
import board
import busio
import adafruit_ads1x15.ads1115 as ADS
from adafruit_ads1x15.analog_in import AnalogIn

# Create the I2C bus
i2c = busio.I2C(board.SCL, board.SDA)
ads = ADS.ADS1115(i2c)

# Create a single-ended input on channel 3
chan = AnalogIn(ads, ADS.P3)

try:
    while True:
        # Read the voltage from the channel
        voltage = chan.voltage
        a = chan.value

        print(f"Channel 3 Voltage: {voltage:.2f} V")
        print(f"Channel 3 Value: {a}")
        
        # Wait for a second before the next reading
        time.sleep(1)
except KeyboardInterrupt:
    print("Program interrupted by user.")
