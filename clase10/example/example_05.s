.global _start              // Declara la etiqueta _start como global (punto de entrada del programa)

.section .text              // Sección de código ejecutable
_start:
    // Valor negativo en 32 bits (W1)
    mov w1, -10            // Carga el valor -10 en el registro W1 (32 bits).
                           // En ARM64, escribir en W1 también pone a cero los 32 bits superiores de X1.

    // --- Usar sin extensión (comportamiento inesperado) ---
    // Aquí X1 contiene una versión zero-extendida implícitamente
    // Porque al escribir W1, se limpian los bits superiores de X1

    add x2, x1, 100        // Suma X1 + 100 y guarda el resultado en X2.
                           // OJO: X1 tiene -10 en los 32 bits bajos y ceros en los altos (zero-extended).
                           // Resultado: X2 = 0xFFFFFFF6 + 100 = 90, pero en 64 bits es 0x0000000A (10) si no se extiende el signo.
                           // Si esperabas -10 en 64 bits, este resultado puede ser inesperado.

    // --- Usar sign extension explícita ---
    sxtw x3, w1            // Extiende con signo W1 a X3 (convierte -10 de 32 a 64 bits correctamente).
                           // Ahora X3 = 0xFFFFFFFFFFFFFFF6 (−10 en 64 bits).

    add x4, x3, 100        // Suma X3 + 100 y guarda el resultado en X4.
                           // Resultado: X4 = 90 (correcto, porque el signo fue extendido).

    // Mostrar mensaje por consola usando la syscall write
    mov x0, 1              // x0 = 1 (descriptor de archivo para stdout)
    ldr x1, =fin_mensaje   // x1 = dirección del mensaje a imprimir
    mov x2, 22             // x2 = longitud del mensaje
    mov x8, 64             // x8 = número de syscall para write en Linux ARM64
    svc 0                  // Llama al sistema operativo para escribir el mensaje

    // Salida del programa usando la syscall exit
    mov x0, 0              // x0 = código de salida 0
    mov x8, 93             // x8 = número de syscall para exit en Linux ARM64
    svc 0                  // Llama al sistema operativo para terminar el programa

.section .data
fin_mensaje:
    .ascii "Fin de extensiones ARM.\n" // Mensaje a mostrar por consola