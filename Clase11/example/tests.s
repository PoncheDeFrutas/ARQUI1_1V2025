.global _start

_start:
    mov x0, 10
    mov x1, 10
    add x2, x0, x1  // x2 = x0 + x1
    add x2, x2, 5   // x2 = x2 + 5


    
    mov x0, x2
    mov x8, 93          // exit syscall_num
    svc 0               // generic syscall
    