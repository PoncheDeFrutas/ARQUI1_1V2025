import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BOARD)
GPIO.setup(7, GPIO.OUT)

try:
    while True:
        GPIO.output(7, GPIO.HIGH)   # Turn on the LED
        time.sleep(1)               # Wait for 1 second
        GPIO.output(7, GPIO.LOW)    # Turn off the LED
        time.sleep(1)               # Wait for 1 second
except KeyboardInterrupt:
    print("Exiting program")

GPIO.cleanup()