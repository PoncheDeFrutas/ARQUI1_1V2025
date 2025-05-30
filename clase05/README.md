# Explicación del Código del Sistema SIEPA (Sistema Integrado de Estación de Monitoreo Ambiental)

Este documento detalla el funcionamiento del código Python que compone el sistema **SIEPA**, el cual está diseñado para leer sensores ambientales y mostrar la información en una pantalla LCD, con la posibilidad de integración futura con servicios como MQTT.

---

## 1. Estructura General del Proyecto

El proyecto está organizado en los siguientes archivos:

* `main.py`: archivo principal que coordina la ejecución.
* `display.py`: gestiona la pantalla LCD.
* `globals.py`: contiene variables compartidas mediante un singleton.
* `sensors.py`: se encarga de leer datos desde sensores.

---

## 2. `main.py`: Lógica Principal del Programa

### Clase `SIEPA`

Esta clase representa el sistema completo. Gestiona el ciclo de ejecución, inicia componentes y maneja subprocesos.

#### `__init__`:

* Inicializa los intervalos de ejecución:

  * `principal`: 0.1 segundos entre lecturas.
  * `MQTT`: 1 segundo (aún no implementado).
* Crea instancias de las clases `Sensors` y `Display`.
* Muestra un mensaje inicial en la pantalla LCD.

#### `run_tasks`:

* Ejecuta tareas repetitivas:

  * Lee sensores.
  * Imprime los datos por consola.
  * Actualiza la pantalla LCD.

#### `mqtt_tasks`:

* Espacio reservado para futuras tareas relacionadas con MQTT.

#### `main_loop`:

* Ejecuta el hilo `mqtt_thread` en paralelo (aunque actualmente está vacío).
* Inicia un bucle principal que corre mientras `self.running` sea `True`.
* Captura interrupciones del teclado para salir con gracia del programa.

---

## 3. `display.py`: Manejo de la Pantalla LCD

### Clase `Display`

Utiliza la librería `rpi_lcd` para controlar una pantalla LCD basada en el chip I2C PCF8574.

#### Atributos importantes:

* `threshold_data`: tiempo mínimo entre actualizaciones de datos (0.5s).
* `threshold_message`: tiempo de espera para mostrar un mensaje especial (5s).

#### `display_data()`:

* Muestra temperatura y humedad en la pantalla.
* Usa los datos compartidos desde `globals.shared`.

#### `display_message(mensaje)`:

* Muestra un mensaje temporal (como errores o avisos).
* Desactiva la actualización de datos mientras se muestra el mensaje.

#### `update()`:

* Determina si se debe mostrar el mensaje de error o los datos.
* Respeta los umbrales temporales para evitar parpadeos frecuentes.

---

## 4. `globals.py`: Estado Global Compartido

### Clase `GlobalState`

Implementa el patrón de diseño **singleton**, lo que asegura que solo haya una instancia global compartida en todo el programa.

#### Atributos compartidos:

* `temperature`: temperatura leída.
* `humidity`: humedad leída.
* `local_error_message`: mensaje de error para mostrar en pantalla si es necesario.

#### Uso:

```python
from globals import shared
print(shared.temperature)
```

---

## 5. `sensors.py`: Lectura de Sensores Ambientales

### Clase `Sensors`

Encapsula la lógica para leer los sensores conectados, actualmente usando un sensor **DHT11** en el pin GPIO 27.

#### `__init__()`:

* Inicializa el objeto `DHT11` de la librería `adafruit_dht`.

#### `read_sensors()`:

* Intenta leer temperatura y humedad.
* Guarda los valores leídos en `shared.temperature` y `shared.humidity`.

#### `print_data()`:

* Imprime por consola los datos obtenidos del sensor.

---

## 6. Flujo de Ejecución

1. El archivo `main.py` crea una instancia de `SIEPA` y llama a `main_loop()`.
2. El sistema inicializa sensores y pantalla, muestra un mensaje inicial.
3. Comienza el ciclo principal:

   * Lee sensores.
   * Imprime datos.
   * Actualiza la pantalla.
4. Si se requiere mostrar un mensaje especial (como un error), se muestra temporalmente.
5. Si se presiona `Ctrl+C`, el programa detiene el bucle y termina limpiamente.

---

## 7. Extensibilidad y Mejora

Este sistema está diseñado para ser **modular y extensible**:

* **MQTT**: se puede integrar usando la función `mqtt_tasks()`.
* **Sensores adicionales**: agregar nuevos sensores en `Sensors.read_sensors()`.
* **Alertas**: usar `shared.local_error_message` para manejar eventos especiales.
* **Pantalla**: se puede mostrar más información ambiental o mensajes de sistema.

---
