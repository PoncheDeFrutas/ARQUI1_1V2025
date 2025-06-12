.global _start

_start:
    mov x0, 9           // return value
    mov x1, 10          //
    mov x2, 9           // return value
    mov x3, 10          //
    mov x0, 0           // return value
    mov x1, 10          //
    mov x2, 9           // return value
    mov x3, 10          //
    
    mov x0, 0
    mov x8, 93          // exit syscall_num
    svc 0               // generic syscall
    