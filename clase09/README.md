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

# Directorios de salida
BIN_C = bin_c
BIN_AS = bin_as
OBJ_DIR = obj

# Crear directorios si no existen
$(shell mkdir -p $(BIN_C) $(BIN_AS) $(OBJ_DIR))

# Si se especifica un archivo como argumento
ifdef archivo
    # Determinar la extensión
    ifeq ($(suffix $(archivo)),.c)
        TARGET = $(BIN_C)/$(basename $(archivo))
        SOURCE = $(archivo)
    else ifeq ($(suffix $(archivo)),.s)
        TARGET = $(BIN_AS)/$(basename $(archivo))_asm
        OBJECT = $(OBJ_DIR)/$(basename $(archivo)).o
        SOURCE = $(archivo)
    else
        $(error El archivo debe tener extensión .c o .s)
    endif
endif

# Regla por defecto
all: $(TARGET)
	@echo "Compilado: $(SOURCE) -> $(TARGET)"
	@if [ -f "$(OBJECT)" ]; then rm -f "$(OBJECT)"; fi

# Regla para archivos .c
$(BIN_C)/%: %.c
	$(CC) -o $@ $<

# Regla para archivos .s (compila a objeto y luego enlaza)
$(BIN_AS)/%_asm: $(OBJ_DIR)/%.o
	$(LD) $< -o $@

$(OBJ_DIR)/%.o: %.s
	$(AS) $< -o $@

# Limpieza
clean:
	rm -rf $(BIN_C) $(BIN_AS) $(OBJ_DIR)

.PHONY: all clean
```

### Cómo usarlo

Guarda tu archivo fuente, por ejemplo `programa.c`, y ejecuta:

```bash
make archivo=programa.c
```

Esto compilará el archivo `programa.c` y generará un binario en el directorio `bin_c`. Si deseas compilar un archivo de ensamblador, simplemente cambia la extensión del archivo a `.s` y usa el mismo comando.

---

## Debugger gdb
Para depurar programas en ARM64, puedes usar `gdb`, el depurador de GNU. Asegúrate de instalarlo:

```bash
sudo apt install gdb -y
```
### Uso básico de gdb
Para depurar un programa compilado, simplemente ejecuta:

```bash
gdb ./hola
```
Dentro de `gdb`, puedes usar comandos como:
## Comandos básicos de GDB para depurar ensamblador ARM64

| Comando           | Descripción                                                                |
| ----------------- | -------------------------------------------------------------------------- |
| `layout src`      | Muestra el código ensamblador en una ventana dividida                      |
| `starti`          | Inicia el programa y se detiene en la primera instrucción                  |
| `ni`              | Avanza a la siguiente instrucción (sin entrar en llamadas)                 |
| `si`              | Avanza paso a paso (entra en llamadas)                                     |
| `info registers`  | Muestra todos los registros                                                |
| `print $x0`       | Imprime el valor del registro x0 (o cualquier otro, como \$x1, \$sp, etc.) |
| `break *0x400080` | Pone un breakpoint en la dirección de memoria 0x400080                     |
| `break _start`    | Pone un breakpoint en la etiqueta `_start`                                 |
| `continue`        | Continúa la ejecución hasta el siguiente breakpoint                        |
| `quit`            | Sale de gdb                                                                |

### Otros comandos últiles

| Comando            | Descripción                                                             |
| ------------------ | ----------------------------------------------------------------------- |
| `disassemble`      | Muestra el código ensamblador generado para la función actual           |
| `x/10i $pc`        | Muestra 10 instrucciones a partir del contador de programa              |
| `x/4x $sp`         | Muestra 4 valores en hexadecimal desde la pila                          |
| `set $x0 = 42`     | Cambia el valor del registro x0 a 42                                    |
| `info breakpoints` | Muestra todos los breakpoints definidos                                 |
| `delete`           | Elimina todos los breakpoints                                           |
| `stepi`            | Alias de `si`, ejecuta una sola instrucción en assembler                |
| `nexti`            | Alias de `ni`, avanza a la siguiente instrucción sin entrar en llamadas |

Con estos comandos puedes hacer una depuración efectiva paso a paso de programas escritos en ensamblador ARM64 utilizando GDB.
