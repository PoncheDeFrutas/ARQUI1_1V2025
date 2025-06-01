// Connect to the WebSocket server
const ws = new WebSocket('ws://localhost:8080');

ws.onopen = () => {
    console.log('Conectado al servidor WebSocket');
};

ws.onmessage = (event) => {
    const data = JSON.parse(event.data);
    updateUI({
        destinationName: data.topic,
        payloadString: data.payload
    });
};

/**
 * Toggles the state of an LED button and communicates the new state via WebSocket.
 *
 * @param {string} elementId - The ID of the button element representing the LED.
 *
 * The function updates the button's text and class to reflect the new state ("ON" or "OFF"),
 * and sends a message with the new state to the WebSocket server using the topic "python/mqtt/Arqui1".
 */
function toggleLED(elementId) {
    const button = document.getElementById(elementId);
    const newState = button.textContent.includes("ON") ? "OFF" : "ON";
    
    // Send the new state to the WebSocket server
    ws.send(JSON.stringify({
        topic: "python/mqtt/Arqui1",
        payload: newState
    }));
    
    // Also update the button text and class
    button.textContent = `LED 1 ${newState}`;
    button.className = newState === "ON" ? "on" : "off";
}

function updateUI(message) {
    const element = document.getElementById('led1');
    if(element) {
        element.textContent = `LED 1 ${message.payloadString}`;
        element.className = message.payloadString === "ON" ? "on" : "off";
    }
}