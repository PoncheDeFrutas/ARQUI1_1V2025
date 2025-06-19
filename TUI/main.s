/*

    This file is the main entry point for the TUI application.
    It initializes the application and starts the main event loop.

*/

/*

    Register usage:
    xzr - zero register (always 0)
    x0
    x1
    x2
    x3
    x4
    x5
    x6
    x7
    x8 - syscall number
    x9
    x10
    x11
    x12
    x13
    x14
    x15
    x16
    x17
    x18
    x19
    x20 - pointer to any string to print
    x21 - length of the string to print
    x22
    x23
    x24
    x25
    x26
    x27
    x28
    x29 - frame pointer
    x30 - link register (return address)
    x31 - stack pointer
*/



.global _start

.section .text

_start:
    ldr x20, =welcome_message   // Load address of welcome message
    mov x21, 32                 // Length of welcome message
    bl print                    // Call print function    

while:
    cmp x0, 5                   // Compare input with 5 (exit option)
    beq end                     // If input is 5, exit the application

    ldr x20, =menu_options      // Load address of menu options
    mov x21, 63                 // Length of menu options
    bl print                    // Call print function
    mov x0, 0                   // Reset input

    b end


print:
    mov x0, 1                   // File descriptor for stdout
    mov x1, x20                 // Address of the string to print
    mov x2, x21                 // Length of the string
    mov x8, 64                  // syscall number for write
    svc 0                       // Make the syscall
    ret                         // Return from print function x30


end:
    mov x0, 0          // Exit code
    mov x8, 93         // syscall number for exit
    svc 0              // Make the syscall




.section .data
welcome_message:
    .ascii "Welcome to the TUI application!\n"
menu_options:
    .ascii "1. Statistics\n2. Predictions\n3. Set File\n4. Set Limits\n5. Exit\n"
rest:
    .ascii "Please enter your choice: "

.section .bss
buffer:
    .space 256