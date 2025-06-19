.global _start          // Define el punto de entrada del programa

.section .text
_start:
    mov x0, 5           // x0 = 5. Guarda el valor base 5 en el registro x0

    lsl x1, x0, 2       // x1 = x0 << 2. Desplaza x0 dos bits a la izquierda (multiplica por 4), resultado: x1 = 20
    lsr x2, x1, 1       // x2 = x1 >> 1 (sin signo). Desplaza x1 un bit a la derecha (divide por 2), resultado: x2 = 10
    asr x3, x1, 1       // x3 = x1 >> 1 (con signo). Desplaza x1 un bit a la derecha conservando el signo, resultado: x3 = 10 (igual porque es positivo)

    mov x4, -8          // x4 = -8. Guarda el valor negativo -8 en x4
    asr x5, x4, 1       // x5 = x4 >> 1 (con signo). Desplaza x4 un bit a la derecha conservando el signo, resultado: x5 = -4
    lsr x6, x4, 1       // x6 = x4 >> 1 (sin signo). Desplaza x4 un bit a la derecha como si fuera sin signo, resultado: valor grande (no -4)

    mov x7, 9           // x7 = 9. Guarda el valor 9 (0b1001) en x7
    ror x8, x7, 1       // x8 = x7 rotado a la derecha 1 bit. 0b1001 -> 0b1100 (12 decimal)

    // Mostrar mensaje por pantalla usando la syscall write
    mov x0, 1           // x0 = 1. Descriptor de archivo 1 (stdout)
    ldr x1, =msg        // x1 = dirección de msg. Apunta al mensaje a imprimir
    mov x2, 29          // x2 = 29. Longitud del mensaje
    mov x8, 64          // x8 = 64. Número de syscall para write
    svc 0               // Llama al sistema operativo para ejecutar la syscall

    // Salida del programa usando la syscall exit
    mov x0, 0           // x0 = 0. Código de salida
    mov x8, 93          // x8 = 93. Número de syscall para exit
    svc 0               // Llama al sistema operativo para terminar el programa

.section .data
msg:
    .ascii "Fin de corrimientos ARMv8-A\n" // Mensaje a mostrar por pantalla
