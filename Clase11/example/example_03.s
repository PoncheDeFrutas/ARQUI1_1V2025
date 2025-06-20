.global _start

.section .text
_start:
    mov x0, 10              // x0 = 10
    mov x1, 20              // x1 = 20

    cmp x0, x1              // Compara x0 y x1, actualiza las banderas del procesador

    // x2 = menor de los dos valores usando csel
    csel x2, x0, x1, lt     // Si x0 < x1, x2 = x0; si no, x2 = x1

    // x3 = valor de x0 si x0 > x1, si no x1 + 1
    csinc x3, x0, x1, gt    // Si x0 > x1, x3 = x0; si no, x3 = x1 + 1

    // x4 = x0 si x0 == x1, si no complemento de x1 (NOT x1)
    csinv x4, x0, x1, eq    // Si x0 == x1, x4 = x0; si no, x4 = ~x1

    // x5 = x0 si x0 != x1, si no -x1
    csneg x5, x0, x1, ne    // Si x0 != x1, x5 = x0; si no, x5 = -x1

    // Mostrar mensaje (por ejemplo, x2 no se muestra, solo el mensaje)
    ldr x6, =msg            // x6 = dirección de msg
    mov x0, 1               // x0 = descriptor de archivo (stdout)
    mov x1, x6              // x1 = puntero al mensaje
    mov x2, 22              // x2 = longitud del mensaje
    mov x8, 64              // x8 = número de syscall (write)
    svc 0                   // llamada al sistema

    mov x0, 0               // x0 = código de salida
    mov x8, 93              // x8 = número de syscall (exit)
    svc 0                   // llamada al sistema para salir

.section .data
msg: .ascii "Condicional sin saltos\n" // Mensaje a mostrar
