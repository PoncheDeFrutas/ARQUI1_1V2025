.global _start

.section .text
_start:
    mov w0, 2000         // 32-bit con signo
    mov w1, -3
    mov x3, 5            // Acumulador 64-bit

    // SMULL: signed 32 × 32 → 64
    smull x4, w0, w1     // x4 = 2000 * -3 = -6000

    // SMADDL: (w0 * w1) + x3
    smaddl x5, w0, w1, x3  // x5 = -6000 + 5 = -5995

    // SMSUBL: (w0 * w1) - x3
    smsubl x6, w0, w1, x3  // x6 = -6000 - 5 = -6005

    // SMNEGL: -(w0 * w1)
    smnegl x7, w0, w1     // x7 = -(-6000) = 6000

    // Valores sin signo
    mov w10, 100
    mov w11, 3
    mov x12, 20

    umull x13, w10, w11      // x13 = 100 * 3 = 300
    umaddl x14, w10, w11, x12 // x14 = 300 + 20 = 320
    umsubl x15, w10, w11, x12 // x15 = 300 - 20 = 280
    umnegl x16, w10, w11      // x16 = -300

    // Mensaje final
    mov x0, 1
    ldr x1, =msj
    mov x2, 34
    mov x8, 64
    svc 0

    // Salir
    mov x0, 0
    mov x8, 93
    svc 0

.section .data
msj:
    .ascii "Fin mult. extendida 32 a 64\n"
