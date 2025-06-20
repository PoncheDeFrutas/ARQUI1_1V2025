.global count_partial       // Make the 'count_partial' symbol globally visible

.section .text              // Place code in the .text section

count_partial:
    //mov x0, x0            // x0 = address of the data
    //mov x1, x1            // x1 = size of the data
    mov x2, 0               // Initialize index to 0
    mov x3, 0               // Initialize count to 0
    mov x29, x30            // Save link register to frame pointer

.count_partial_loop:
    cmp x2, x1              // Compare index with size
    beq .count_partial_done // If index equals size, we are done
    ldrb w4, [x0, x2]       // Load byte from data at index x2
    cmp w4, 10              // Check if byte is newline (ASCII 10)
    cinc x3, x3, eq         // Increment count if byte is newline
    add x2, x2, 1           // Increment index
    b .count_partial_loop   // Repeat the loop

.count_partial_done:
    mov x0, x3              // Move count to x0 (return value)
    mov x30, x29            // Restore link register from frame pointer
    ret                      // Return from function
