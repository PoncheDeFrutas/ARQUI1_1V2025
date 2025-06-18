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
    MOV  X0, 0               // Código de salida 0 (sin errores)
    MOV  X8, 93              // Número de syscall para 'exit' en AArch64
    SVC  0                    // Llama al sistema operativo para terminar el programa