.global _start

.section .text
_start:
    // Cargar el primer número (6) en x0
    mov x0, 6         

    // Cargar el segundo número (4) en x1
    mov x1, 4         

    // Multiplicar x0 * x1 y guardar el resultado en x2 (x2 = 6 * 4 = 24)
    mul x2, x0, x1    

    // Cargar el valor 10 en x3
    mov x3, 10

    // Multiplicar x0 * x1, sumar x3 y guardar en x4 (x4 = (6 * 4) + 10 = 34)
    madd x4, x0, x1, x3   

    // Multiplicar x0 * x1, restar x3 y guardar en x5 (x5 = (6 * 4) - 10 = 14)
    msub x5, x0, x1, x3   

    // Multiplicar x0 * x1, cambiar el signo y guardar en x6 (x6 = -(6 * 4) = -24)
    mneg x6, x0, x1       

    // Preparar los registros para escribir el mensaje en pantalla
    mov x0, 1            // Descriptor de archivo 1 (stdout)
    ldr x1, =msg         // Dirección del mensaje
    mov x2, 26           // Longitud del mensaje
    mov x8, 64           // Número de syscall para write
    svc 0                // Llamada al sistema

    // Salir del programa
    mov x0, 0            // Código de salida 0
    mov x8, 93           // Número de syscall para exit
    svc 0                // Llamada al sistema

.section .data
msg:
    .ascii "Fin de multiplicación ARM\n" // Mensaje a mostrar
