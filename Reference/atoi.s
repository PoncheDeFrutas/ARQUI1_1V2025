/*

    This file is part of the TUI project.
    It contains the implementation of the atoi function, which converts a string
    representation of an integer to its actual integer value.
    It reads characters from the string, checks if they are digits, and accumulates
    the result by multiplying the current result by 10 and adding the new digit.
    The function stops processing when it encounters a non-digit character or the end of the string.

*/

/* 

    Register usage:
    x0  - pointer to the string to convert
    x1  - result (accumulator for the integer value)
    x2  - pointer to the current character in the string
    w3  - current character (byte) being processed
    x4  - temporary register for current result
    x5  - constant value 10 for multiplication

*/


.global atoi                // Function to convert a string to an integer

.section .text  
atoi:
    mov x1, 0               // Initialize result to 0
    mov x2, x0              // x0 contains the address of the string to convert 
    mov x5, 10              // Load 10 into x5  
.atoi_loop:
    ldrb w3, [x2], 1        // Load byte from string and increment pointer
    cmp w3, #'0'            // Check if character is '0'
    blt .atoi_done          // If less than '0', we are done
    cmp w3, #'9'            // Check if character is '9'    
    bgt .atoi_done          // If greater than '9', we are done

    // Convert ASCII character to integer
    // result = result * 10 + (w3 - '0')
    mov x4, x1              // Store current result in x4
    mul x1, x4, x5          // result = result * 10
    sub w3, w3, #'0'        // Convert ASCII to integer
    add x1, x1, x3          // result = result + (w3 - '0')
    b .atoi_loop            // Repeat the loop for next character

.atoi_done:
    mov x0, x1
    ret
