.global _start

.section .text
_start:
    // --- Suma básica ---
    mov x0, 10
    mov x1, 25
    add x2, x0, x1      // x2 = 10 + 25 = 35

    // --- Resta básica ---
    sub x3, x1, x0      // x3 = 25 - 10 = 15

    // --- Negación ---
    neg x4, x0          // x4 = -10

    // --- Suma con acarreo (simulación simple) ---
    // Hacemos una suma grande que activa el carry

    mov x5, -1          // x5 = 0xFFFFFFFFFFFFFFFF (todos los bits en 1)
    mov x6, 1
    adds x7, x5, x6     // x7 = x5 + x6 = 0, carry = 1

    // Ahora usamos el carry en una segunda suma
    adcs x8, xzr, xzr   // x8 = 0 + 0 + carry = 1

    // Mensaje final
    mov x0, 1
    ldr x1, =fin_mensaje
    mov x2, 20
    mov x8, 64
    svc 0

    // Salir
    mov x0, 0
    mov x8, 93
    svc 0

.section .data
fin_mensaje:
    .ascii "Fin de operaciones.\n"
