import spidev
import time
import RPi.GPIO as GPIO

#SPI configuration
spi = spidev.SpiDev()
spi.open(0, 0)  # Open bus 0, device 0
spi.max_speed_hz = 1000000 # Set maximum speed to 1 MHz

#The chip select pin is connected to GPIO 12, depending on it the SPI device will be read or not read
CS_ADC = 12
GPIO.setup(CS_ADC, GPIO.OUT)

def analogRead(channel):
    """
    Read an analog value from the specified channel.
    :param channel: The ADC channel to read from (0-7).
    :return: The analog value read from the ADC.
    """
    adc = spi.xfer2([6| (channel >> 2), channel << 6, 0]) # Send the command to read the ADC
    data = ((adc[1] &  15) << 8) | adc[2]  # Combine the received bytes to get the ADC value

    adc_value = 3.3 * (data / (2**12-1))  # Convert the ADC value to a voltage
    return adc_value

while True:
    GPIO.output(CS_ADC, GPIO.LOW)  # Enable the ADC by setting CS low
    value = analogRead(0)  # Read from channel 0
    GPIO.output(CS_ADC, GPIO.HIGH)  # Disable the ADC by setting CS high

    print(f"Analog value: {value:.2f} V")  # Print the read value
    time.sleep(1)  # Wait for 1 second before the next reading