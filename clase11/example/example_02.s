.global _start          // Define el punto de entrada del programa

.section .text          // Sección de código

_start:
    mov x0, 15          // Carga el primer número (15) en el registro x0
    mov x1, 30          // Carga el segundo número (30) en el registro x1

    cmp x0, x1          // Compara x0 con x1 (x0 - x1), actualiza los flags NZCV

    beq iguales         // Si los valores son iguales (flag Z=1), salta a la etiqueta 'iguales'
    bgt mayor           // Si x0 > x1 (signed, flag N=V y Z=0), salta a 'mayor'
    blt menor           // Si x0 < x1 (signed, flag N!=V), salta a 'menor'

    b fin               // Por seguridad, salta a 'fin' si no se cumple ninguna condición anterior

iguales:
    ldr x2, =msg_eq     // Carga la dirección del mensaje "Los valores son iguales\n" en x2
    b imprimir          // Salta a la rutina de impresión

mayor:
    ldr x2, =msg_mayor  // Carga la dirección del mensaje "El primero es mayor\n" en x2
    b imprimir          // Salta a la rutina de impresión

menor:
    ldr x2, =msg_menor  // Carga la dirección del mensaje "El primero es menor\n" en x2

imprimir:
    mov x0, 1           // x0 = 1 (descriptor de archivo para stdout)
    mov x1, x2          // x1 = dirección del mensaje a imprimir
    mov x2, 20          // x2 = longitud del mensaje (20 bytes)
    mov x8, 64          // x8 = número de syscall para write (64)
    svc 0               // Llama al sistema operativo para escribir el mensaje

fin:
    mov x0, 0           // x0 = código de salida 0
    mov x8, 93          // x8 = número de syscall para exit (93)
    svc 0               // Llama al sistema operativo para terminar el programa

.section .data          // Sección de datos

msg_eq:     .ascii "Los valores son iguales\n"   // Mensaje para valores iguales
msg_mayor:  .ascii "El primero es mayor\n"       // Mensaje para x0 > x1
msg_menor:  .ascii "El primero es menor\n"       // Mensaje para x0 < x1
