# Store and Load

A continuación se muestra un ejemplo en ensamblador AArch64 que ilustra el uso de las instrucciones **load** (cargar) y **store** (almacenar) para manipular datos en memoria:

```assembly
// archivo: ejemplo64.s

// Sección de datos: aquí se definen variables globales
.section .data
valor:     .quad 123456789    // Define una variable 'valor' de 8 bytes con el valor 123456789
espacio:   .quad 0            // Define una variable 'espacio' de 8 bytes inicializada en 0

// Sección de código
.section .text
.global _start                // Hace visible el símbolo '_start' como punto de entrada

_start:
    // Cargar la dirección de 'valor' en X0
    ADRP X0, valor            // Carga la parte alta de la dirección de 'valor' en X0
    ADD  X0, X0, :lo12:valor  // Suma la parte baja para obtener la dirección completa
    LDR  X1, [X0]             // Carga el contenido de 'valor' en X1

    // Cargar la dirección de 'espacio' en X2
    ADRP X2, espacio          // Carga la parte alta de la dirección de 'espacio' en X2
    ADD  X2, X2, :lo12:espacio// Suma la parte baja para obtener la dirección completa
    STR  X1, [X2]             // Guarda el valor de X1 (123456789) en 'espacio'

    // Finaliza el programa usando una syscall de salida
    MOV  X8, #93              // Número de syscall para 'exit' en AArch64
    MOV  X0, #0               // Código de salida 0 (sin errores)
    SVC  0                    // Llama al sistema operativo para terminar el programa
```

## Explicación detallada de Load y Store

En este ejemplo se utilizan dos instrucciones clave para manipular datos en memoria:

- **LDR (Load Register):** Esta instrucción carga un valor desde una dirección de memoria a un registro.  
  En el código, `LDR X1, [X0]` toma el valor almacenado en la dirección apuntada por `X0` (que corresponde a la variable `valor`) y lo coloca en el registro `X1`.

- **STR (Store Register):** Esta instrucción almacena el valor de un registro en una dirección de memoria.  
  En el código, `STR X1, [X2]` toma el valor que está en el registro `X1` (que ahora contiene el valor de `valor`) y lo almacena en la dirección apuntada por `X2` (que corresponde a la variable `espacio`).

### Flujo de ejecución

1. **Obtener direcciones:**  
   Se usan las instrucciones `ADRP` y `ADD` para calcular la dirección completa de las variables `valor` y `espacio` y almacenarlas en los registros `X0` y `X2`, respectivamente.

2. **Cargar (Load):**  
   `LDR X1, [X0]` lee el valor de `valor` (123456789) desde memoria y lo coloca en el registro `X1`.

3. **Almacenar (Store):**  
   `STR X1, [X2]` toma el valor de `X1` y lo escribe en la dirección de `espacio`, copiando así el valor de `valor` en `espacio`.

Estas operaciones son fundamentales en la arquitectura de computadoras, ya que permiten transferir datos entre la memoria y los registros del procesador.

