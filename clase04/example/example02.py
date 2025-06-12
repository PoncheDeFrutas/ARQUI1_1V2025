import time
import board
import adafruit_bmp280

i2c = board.I2C()  # uses board.SCL and board.SDA
bmp280 = adafruit_bmp280.Adafruit_BMP280_I2C(i2c, address=0x76)

bmp280.sea_level_pressure = 1022

try:
    while True:
        temperature = bmp280.temperature
        pressure = bmp280.pressure
        altitude = bmp280.altitude

        if temperature is not None:
            print(f"Temperature: {temperature:.2f} C")
        else:
            print("Temperature: N/A")

        if pressure is not None:
            print(f"Pressure: {pressure:.2f} hPa")
        else:
            print("Pressure: N/A")

        if altitude is not None:
            print(f"Altitude: {altitude:.2f} m")
        else:
            print("Altitude: N/A")

        time.sleep(2)
except KeyboardInterrupt:
    print("Program stopped by user.")