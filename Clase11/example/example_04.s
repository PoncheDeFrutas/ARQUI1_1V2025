.global _start

.section .text
_start:
    mov x0, 5          // x0 = 5
    mov x1, 10         // x1 = 10
    mov x2, -7         // x2 = -7

    cmp x0, x1         // Compara x0 y x1 (5 < 10), actualiza los flags

    cinc x0, lt        // Si x0 < x1 (lt=true), x0 = x0 + 1 (6); si no, x0 sin cambios
    cinv x1, lt        // Si x0 < x1 (lt=true), x1 = ~x1 (bitwise NOT de 10); si no, x1 sin cambios
    cneg x2, eq        // Si x0 == x1 (eq=false), x2 sin cambios; si no, x2 = -x2

    // Al final:
    // x0 = 6
    // x1 = ~10 (bitwise NOT)
    // x2 = -7

    // Salir del programa
    mov x0, 0          // Código de salida 0
    mov x8, 93         // Número de syscall para exit en Linux ARM64
    svc 0              // Llamada al sistema
