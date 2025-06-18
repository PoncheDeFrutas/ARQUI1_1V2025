.global _start          // Define el símbolo global _start como punto de entrada

.section .text          // Sección de código

_start:
    // === MOV ===
    mov x0, 10          // Coloca el valor inmediato 10 en el registro x0
    mov x1, x0          // Copia el valor de x0 en x1

    // === MOVZ + MOVK ===
    movz x2, 500        // Coloca el valor 500 en los bits 0-15 de x2, el resto en 0
    movk x2, 1000, lsl 16  // Inserta 1000 en los bits 16-31 de x2, el resto no cambia
    movk x2, 1500, lsl 32  // Inserta 1500 en los bits 32-47 de x2, el resto no cambia

    // === MOVN ===
    movn x3, 0          // Coloca el complemento a uno de 0 en x3 (es decir, x3 = -1)
    movn x4, 1000       // Coloca el complemento a uno de 1000 en x4 (NOT 1000)

    // Mostrar mensaje para saber que terminó
    mov x0, 1           // x0 = descriptor de archivo (1 = salida estándar)
    ldr x1, =fin_mensaje // x1 = dirección del mensaje a imprimir
    mov x2, 20          // x2 = longitud del mensaje (20 bytes)
    mov x8, 64          // x8 = número de syscall para write
    svc 0               // Llamada al sistema (escribe el mensaje en pantalla)

    // exit(0)
    mov x0, 0           // x0 = código de salida 0
    mov x8, 93          // x8 = número de syscall para exit
    svc 0               // Llamada al sistema (termina el programa)

.section .data          // Sección de datos

fin_mensaje:
    .ascii "Fin de movimientos.\n" // Mensaje a mostrar
