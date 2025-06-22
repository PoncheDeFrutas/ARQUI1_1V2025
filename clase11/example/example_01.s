.global _start

.section .text
_start:
    mov x0, 7          // x0 = 7
    mov x1, 7          // x1 = 7

    cmp x0, x1         // Compara x0 y x1 (¿x0 == x1?)
    b.eq iguales       // Si son iguales, salta a la etiqueta 'iguales'

    cmn x0, x1         // Suma x0 + x1 y actualiza los flags (¿hay overflow?)
    bvs overflow       // Si hay overflow (flag V), salta a 'overflow'

    tst x0, x1         // Realiza AND entre x0 y x1, actualiza los flags (¿bits en común?)
    bne comun          // Si el resultado no es cero (hay bits en común), salta a 'comun'

    b fin              // Si no se cumple ninguna condición anterior, salta a 'fin'

iguales:
    ldr x2, =msg_ig    // Carga la dirección del mensaje "Son iguales los valores" en x2
    b fin              // Salta a 'fin'

overflow:
    ldr x2, =msg_ovf   // Carga la dirección del mensaje "Hubo overflow en suma" en x2
    b fin              // Salta a 'fin'

comun:
    ldr x2, =msg_and   // Carga la dirección del mensaje "Tienen bits en común" en x2

fin:
    mov x0, 1          // x0 = 1 (file descriptor stdout)
    mov x1, x2         // x1 = dirección del mensaje a imprimir
    mov x2, 25         // x2 = número de bytes a escribir (25)
    mov x8, 64         // x8 = número de syscall para write
    svc 0              // Llama al sistema para escribir el mensaje

    mov x0, 0          // x0 = 0 (código de salida)
    mov x8, 93         // x8 = número de syscall para exit
    svc 0              // Llama al sistema para terminar el programa

.section .data
msg_ig:  .ascii "Son iguales los valores\n"      // Mensaje si los valores son iguales
msg_ovf: .ascii "Hubo overflow en suma\n"        // Mensaje si hubo overflow en la suma
msg_and: .ascii "Tienen bits en común\n"         // Mensaje si tienen bits en común
