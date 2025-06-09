# Import the RPi.GPIO library for controlling the Raspberry Pi's GPIO pins
import RPi.GPIO as GPIO
# Import the time library for delays and measuring time intervals
import time

# Define the GPIO pin numbers for the ultrasonic sensor's TRIG and ECHO pins
TRIG = 8   # Pin used to send the trigger pulse
ECHO = 10  # Pin used to receive the echo pulse

# Set the GPIO pin numbering mode to BOARD (physical pin numbers)
GPIO.setmode(GPIO.BOARD)
# Set up the TRIG pin as an output (to send pulses)
GPIO.setup(TRIG, GPIO.OUT)
# Set up the ECHO pin as an input (to receive pulses)
GPIO.setup(ECHO, GPIO.IN)

def medir_distancia():
    """
    Measures the distance using an ultrasonic sensor connected to the GPIO pins.

    The function triggers the ultrasonic sensor to send a pulse and measures the time taken
    for the echo to return. It then calculates the distance based on the speed of sound.

    Returns:
        float: The measured distance in centimeters, rounded to two decimal places.

    Note:
        Assumes that the GPIO pins TRIG and ECHO are properly configured and that the
        GPIO and time modules are imported.
    """
    # Ensure the TRIG pin is low before starting a measurement
    GPIO.output(TRIG, False)
    time.sleep(0.1)  # Wait for sensor to settle

    # Send a 10 microsecond pulse to the TRIG pin to start measurement
    GPIO.output(TRIG, True)
    time.sleep(0.00001)  # 10 microseconds
    GPIO.output(TRIG, False)

    # Wait for the ECHO pin to go high (start of the echo pulse)
    while GPIO.input(ECHO) == 0:
        inicio = time.time()  # Record the start time

    # Wait for the ECHO pin to go low (end of the echo pulse)
    while GPIO.input(ECHO) == 1:
        fin = time.time()  # Record the end time

    # Calculate the duration of the echo pulse
    duracion = fin - inicio  # type: ignore

    # Calculate the distance based on the duration and speed of sound (34300 cm/s)
    # Divide by 2 because the pulse travels to the object and back
    distancia = duracion * 34300 / 2

    # Return the distance rounded to two decimal places
    return round(distancia, 2)

try:
    # Continuously measure and print the distance until interrupted
    while True:
        dist = medir_distancia()  # Measure distance
        print("Distancia:", dist, "cm")  # Print the measured distance
        time.sleep(1)  # Wait for 1 second before the next measurement
except KeyboardInterrupt:
    # Clean up the GPIO settings when the user interrupts the program (Ctrl+C)
    GPIO.cleanup()
