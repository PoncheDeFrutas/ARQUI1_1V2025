import smbus
"""
This script reads analog values from channel A0 of a PCF8591 I2C analog-to-digital converter using the smbus library on a Raspberry Pi.

Modules:
    smbus: Provides I2C communication.
    time: Used to introduce delays between readings.

Constants:
    address (int): I2C address of the PCF8591 device.
    A0 (int): Command byte to select analog input channel A0.

Workflow:
    - Initializes the I2C bus.
    - Continuously selects channel A0 on the PCF8591.
    - Reads the analog value from channel A0.
    - Prints the value to the console.
    - Waits for 1 second before repeating.

Note:
    - Ensure the PCF8591 is connected to the correct I2C bus and address.
    - Uncomment and use A1, A2, or A3 to read from other channels if needed.
"""
import time

address = 0x48  # Address of the I2C device (PCF8591)
A0 = 0x40  # Channel A0
#A1 = 0x41  # Channel A1
#A2 = 0x42  # Channel A2
#A3 = 0x43  # Channel A3

bus = smbus.SMBus(1)  # Create an I2C bus object

while True:
    bus.write_byte(address, A0)  # Select channel A0
    value = bus.read_byte(address)  # Read the value from the device
    print(f"Value from A0: {value}")  # Print the value read from channel A0
    time.sleep(1)  # Wait for 1 second before the next read