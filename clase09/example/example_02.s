.global _start

.section .text
_start:
    // write(1, mensaje, 18)
    mov x0, 1              // file descriptor 1 (stdout)
    ldr x1, =mensaje       // dirección del mensaje
    mov x2, 21             // longitud del mensaje
    mov x8, 64             // syscall write
    svc 0

    // exit(0)
    mov x0, 0              // código de salida
    mov x8, 93             // syscall exit
    svc 0

.section .data
mensaje:
    .ascii "Hola desde ASM ARM64\n"
