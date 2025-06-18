.global _start

.section .text
_start:
    // Carga el valor 12 (1100 en binario) en el registro x0
    mov x0, 12        

    // Carga el valor 10 (1010 en binario) en el registro x1
    mov x1, 10        

    // AND lógico: x2 = x0 & x1 = 8 (1000 en binario)
    and x2, x0, x1

    // BIC (AND con complemento): x3 = x0 & ~x1 = 4 (0100 en binario)
    bic x3, x0, x1

    // XOR lógico: x4 = x0 ^ x1 = 6 (0110 en binario)
    eor x4, x0, x1

    // EON (XOR con complemento): x5 = x0 ^ ~x1 = 9 (1001 en binario)
    eon x5, x0, x1

    // OR lógico: x6 = x0 | x1 = 14 (1110 en binario)
    orr x6, x0, x1

    // ORN (OR con complemento): x7 = x0 | ~x1
    orn x7, x0, x1

    // MVN (NOT): x8 = ~x1
    mvn x8, x1

    // Prepara los registros para escribir el mensaje en pantalla
    mov x0, 1                  // Descriptor de archivo 1 (stdout)
    ldr x1, =fin_mensaje       // Dirección del mensaje
    mov x2, 23                 // Longitud del mensaje
    mov x8, 64                 // Número de syscall para write
    svc 0                      // Llamada al sistema

    // Termina el programa
    mov x0, 0                  // Código de salida 0
    mov x8, 93                 // Número de syscall para exit
    svc 0                      // Llamada al sistema

.section .data
fin_mensaje:
    .ascii "Fin de lógica binaria ARM\n" // Mensaje a mostrar
