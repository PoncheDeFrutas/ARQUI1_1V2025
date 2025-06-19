.global _start

.section .text
/*
    Este programa demuestra el uso de las instrucciones lógicas ANDS y BICS 
    con establecimiento de banderas en ensamblador ARM64. Compara dos números usando ANDS, 
    verifica el resultado y luego usa BICS para limpiar bits y verifica de nuevo. 
    Dependiendo de los resultados, imprime diferentes mensajes en la consola.
*/
_start:
    mov x0, 12       // Carga 12 (binario 1100) en x0
    mov x1, 10       // Carga 10 (binario 1010) en x1

    // --- ANDS con establecimiento de banderas ---
    ands x2, x0, x1   // x2 = x0 & x1 = 8; establece banderas según el resultado
    beq no_es_cero   // Salta si el resultado es cero (no lo es, así que no salta)

    // --- BICS con establecimiento de banderas ---
    bics x3, x0, x0   // x3 = x0 & ~x0 = 0; establece banderas según el resultado
    beq es_cero      // Salta si el resultado es cero (lo es, así que salta)

fin:
    // Imprime mensaje final
    mov x0, 1             // Descriptor de archivo: stdout
    ldr x1, =msj_fin      // Dirección del mensaje
    mov x2, 20            // Longitud del mensaje
    mov x8, 64            // Número de syscall para write
    svc 0                 // Realiza syscall

    mov x0, 0             // Código de salida 0
    mov x8, 93            // Número de syscall para exit
    svc 0                 // Realiza syscall

no_es_cero:
    // Imprime mensaje "El resultado no es cero"
    ldr x1, =msj_no_cero  // Dirección del mensaje
    mov x2, 17            // Longitud del mensaje
    b fin                 // Ir al final

es_cero:
    // Imprime mensaje "El resultado es cero"
    ldr x1, =msj_es_cero  // Dirección del mensaje
    mov x2, 15            // Longitud del mensaje
    b fin                 // Ir al final

.section .data
msj_no_cero:
    .ascii "Result is not zero.\n"

msj_es_cero:
    .ascii "Result is zero\n"

msj_fin:
    .ascii "End of logical flags\n"
