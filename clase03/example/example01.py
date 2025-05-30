import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BOARD)
GPIO.setup(11, GPIO.OUT)
GPIO.setwarnings(False)

try:
    while True:
        try:
            print("Blinking LED every second...")
            GPIO.output(11, GPIO.HIGH)   # Turn on the LED
            time.sleep(1)               # Wait for 1 second
            GPIO.output(11, GPIO.LOW)    # Turn off the LED
            time.sleep(1)               # Wait for 1 second
        except RuntimeError as e:
            print(f"RuntimeError: {e.args[0]}")
        except Exception as e:
            GPIO.cleanup()
            print(f"Exception: {e}")
except KeyboardInterrupt:
    print("Exiting program")
finally:
    GPIO.cleanup()