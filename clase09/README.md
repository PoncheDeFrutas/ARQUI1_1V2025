# ARM64 con Raspberry pi

## Paso 2: Primer arranque y configuración inicial

Una vez que hayas instalado el sistema operativo Raspberry Pi OS de 64 bits en tu tarjeta microSD y encendido la Raspberry Pi, se iniciará el asistente de configuración. Este proceso es fundamental para asegurar que el entorno esté correctamente preparado para programar y compilar código ARM64.

### Configuración inicial

1. **Selecciona el idioma y la región**: Esto garantizará que los formatos de hora, teclado y moneda sean correctos para tu ubicación.
2. **Conéctate a una red WiFi** (si no usas cable Ethernet): Es esencial para poder descargar paquetes y actualizaciones.
3. **Cambia la contraseña por defecto** del usuario "pi" por razones de seguridad.
4. **Habilita actualizaciones automáticas** si deseas que tu sistema se mantenga actualizado sin intervención manual.
5. **Reinicia** si el sistema lo solicita.

### Actualización del sistema

Una vez que el escritorio esté disponible, abre una terminal y ejecuta lo siguiente:

```bash
sudo apt update && sudo apt full-upgrade -y
```

Esto actualizará todos los paquetes del sistema a sus versiones más recientes, corrigiendo posibles errores de seguridad y mejorando la estabilidad general.

---

## Paso 2: Instalar herramientas de desarrollo para ARM64

Ahora que tu sistema está listo, necesitas instalar herramientas esenciales para programar y compilar código en arquitectura ARM64. Como el sistema operativo es de 64 bits, cualquier programa que compiles será por defecto ARM64.

### Instalación del toolchain básico (C/C++)

```bash
sudo apt install build-essential gcc g++ cmake git -y
```

* `build-essential`: Incluye GCC, G++, make y otras utilidades necesarias para compilar código en C/C++.
* `cmake`: Herramienta para gestionar la construcción de proyectos grandes.
* `git`: Control de versiones para clonar y gestionar repositorios.

---

## Paso 3: Compilar código ARM64

Una vez instaladas las herramientas, puedes compilar directamente en tu Raspberry Pi. Al estar sobre una arquitectura ARM64, el binario generado por defecto será para esa arquitectura.

### Ejemplo en C

```c
#include <stdio.h>

int main() {
    printf("Hola desde ARM64!\n");
    return 0;
}
```

Guarda el archivo como `hola.c` y compila con:

```bash
gcc -o hola hola.c
```

Verifica el tipo de binario generado:

```bash
file hola
```

La salida debería ser:

```
hola: ELF 64-bit LSB executable, ARM aarch64, ...
```

Esto confirma que el binario es ARM64.

Para ejecutar el programa, simplemente usa:

```bash
./hola
```

---

## Paso 4.1: Automatización de compilación con Make

`make` es una herramienta muy útil para automatizar la compilación de programas, especialmente cuando trabajas con varios archivos o quieres simplificar el proceso.

### Ventajas de usar `make`

* Permite compilar fácilmente sin recordar los comandos completos.
* Facilita la separación entre el código fuente y los binarios generados.
* Solo recompila archivos que han cambiado.
* Mejora la organización del proyecto.

### Makefile básico para C o ensamblador

Puedes crear un archivo llamado `Makefile` con el siguiente contenido:

```makefile
# Compiladores
CC = gcc
AS = as
LD = ld

# Flags para debug
ASFLAGS = -g
LDFLAGS = -g

# Directorios de salida
BIN_C = bin_c
BIN_AS = bin_as
OBJ_DIR = obj

# Crear directorios si no existen
$(shell mkdir -p $(BIN_C) $(BIN_AS) $(OBJ_DIR))

# Si se especifica un archivo como argumento
ifdef archivo
    ifeq ($(suffix $(archivo)),.c)
        TARGET = $(BIN_C)/$(basename $(archivo))
        SOURCE = $(archivo)
        COMPILE_CMD = $(CC) -g $(SOURCE) -o $(TARGET)
    else ifeq ($(suffix $(archivo)),.s)
        TARGET = $(BIN_AS)/$(basename $(archivo))_asm
        OBJECT = $(OBJ_DIR)/$(basename $(archivo)).o
        SOURCE = $(archivo)
        COMPILE_CMD = $(AS) $(ASFLAGS) $(SOURCE) -o $(OBJECT) && $(LD) $(LDFLAGS) $(OBJECT) -o $(TARGET)
    else
        $(error El archivo debe tener extensión .c o .s)
    endif
endif

# Regla por defecto que compila, pero no ejecuta gdb
all:
ifndef archivo
    @echo "Error: Debes especificar un archivo con 'make archivo=archivo.c|.s'"
else
    @echo "Compilando $(SOURCE)..."
    @$(COMPILE_CMD)
    @echo "Compilación completa. Binario: $(TARGET)"
endif

# Limpieza
clean:
    rm -rf $(BIN_C) $(BIN_AS) $(OBJ_DIR)

# Debug
debug: all
    @if [ -f "$(TARGET)" ]; then \
        echo "Ejecutando GDB para depuración..."; \
        gdb -q $(TARGET); \
    else \
        echo "Error: El target no existe. Usa 'make archivo=archivo.s' primero."; \
    fi

.PHONY: all clean debug
```

---

## ¿Cómo funciona el Makefile y cómo utilizarlo?

El Makefile presentado automatiza la compilación de archivos fuente en C (`.c`) o ensamblador (`.s`). Según el archivo que especifiques, compila y organiza los binarios en carpetas separadas. También permite limpiar los archivos generados y depurar con GDB.

### Uso básico

- **Compilar un archivo C o ensamblador:**

  ```bash
  make archivo=hola.c
  make archivo=ejemplo.s
  ```

  Esto compilará el archivo y dejará el binario en la carpeta correspondiente (`bin_c` o `bin_as`).

- **Limpiar archivos generados:**

  ```bash
  make clean
  ```

  Elimina los binarios y objetos generados.

- **Depurar con GDB:**

  ```bash
  make archivo=hola.c debug
  ```

  Compila el archivo y abre GDB para depuración.

### ¿Qué hace cada parte?

- **Variables:** Define los compiladores, flags y carpetas de salida.
- **Reglas:** 
  - `all`: Compila el archivo especificado.
  - `clean`: Limpia los binarios y objetos.
  - `debug`: Compila y abre GDB si el binario existe.

---

## Comandos básicos de GDB para analizar código ARM

GDB es el depurador estándar en Linux y permite analizar el comportamiento de programas ARM64.

### Comandos útiles

- `break main`  
  Coloca un breakpoint en la función `main`.

- `run`  
  Inicia la ejecución del programa.

- `next`  
  Ejecuta la siguiente línea de código (sin entrar en funciones).

- `step`  
  Ejecuta la siguiente línea de código (entrando en funciones).

- `print <variable>`  
  Muestra el valor de una variable.

- `info registers`  
  Muestra el estado de los registros del procesador ARM64.

- `disassemble`  
  Muestra el código ensamblador del programa.

- `continue`  
  Continúa la ejecución hasta el siguiente breakpoint.

- `quit`  
  Sale de GDB.

### Ejemplo de sesión GDB

```bash
make archivo=hola.c debug
```

Dentro de GDB:

```
(gdb) break main
(gdb) run
(gdb) next
(gdb) print variable
(gdb) info registers
(gdb) disassemble
(gdb) continue
(gdb) quit
```

Estos comandos te ayudarán a analizar y depurar tus programas ARM64 en la Raspberry Pi.
