from rpi_lcd import LCD
from time import sleep

# Initialize the LCD with the I2C address, bus, number of rows, and columns and backlight status
lcd = LCD(0x27, 1, 16, 2, True)

# Set the messages to display, text, line, align

lcd.text('Hello World!', 1)
lcd.text('Raspberry Pi', 2)

sleep(5)

# Clear the LCD display
lcd.clear()

# Set position and display a new message
lcd.text('New Message', 1, 'center')
sleep(2)

lcd.clear()