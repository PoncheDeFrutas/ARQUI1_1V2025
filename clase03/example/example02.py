import time
import board
import adafruit_dht
import RPi.GPIO as GPIO

dht = adafruit_dht.DHT11(board.D27)


while True:
    try:
        temperature_c = dht.temperature
        temperature_f = temperature_c * (9 / 5) + 32 # type: ignore
        humidity = dht.humidity
        print(f"Temp: {temperature_c:.1f} C / {temperature_f:.1f} F, Humidity: {humidity:.1f}%")
    except RuntimeError as e:
        print(f"RuntimeError: {e.args[0]}")
    except Exception as e:
        dht.exit()
        raise e
    except KeyboardInterrupt:
        print("Exiting program")
        break
    time.sleep(2.0)  # Wait for 2 seconds before the next reading

GPIO.cleanup()  # Clean up GPIO settings on exit