.global atoi_partial       // Make the 'atoi_partial' symbol globally visible

.section .text              // Place code in the .text section

atoi_partial:
    //mov x0, x0            // x0 = address of the data
    //mov x1, x1            // x1 = size of the data
    mov x2, 0               // Initialize index to 0
    mov x3, 0               // Partial Result (Accumulator)
    mov x4, 0               // Final Result
    mov x5, 10              // Load 10 into x5 (constant for multiplication)
    mov x6, 0               // Initialize current digit
    mov x7, 0               // Flag to indicate if a digit was read
    mov x29, x30            // Save link register to frame pointer

.atoi_partial_loop:
    cmp x2, x1              // Compare index with size
    beq .atoi_partial_done  // If index equals size, we are done

    ldrb w6, [x0, x2]       // Load byte from data at index x2
    cmp w6, 36              // Check if byte is '$' (ASCII 36)
    beq .atoi_partial_end   // If '$' found, end processing
    cmp w6, 10              // Check if byte is newline (ASCII 10)
    beq .atoi_partial_store // If newline found, store the result    

    cmp w6, #'0'            // Check if character is '0'
    blt .atoi_partial_skip  // If less than '0', skip to next character
    cmp w6, #'9'            // Check if character is '9'
    bgt .atoi_partial_skip  // If greater than '9', skip to next character

    // Convert ASCII character to integer
    sub w6, w6, #'0'        // Convert ASCII to integer
    mul x3, x3, x5          // result = result * 10
    add x3, x3, x6          // result = result + (w6 - '0')
    mov x7, 1               // Set digit flag to indicate a digit
    b .atoi_partial_advance    // Repeat the loop for next character


.atoi_partial_store:
    cmp x7, 1
    bne .atoi_partial_advance // If a digit was read, skip to advance
    mov x4, x3              // Move the accumulated result to x4
    mov x3, 0               // Reset accumulator for next number
    mov x7, 0               // Reset digit flag
    b .atoi_partial_advance  // Continue to next character

.atoi_partial_skip:

   // Add this to skip non-digit characters   194AKDJFA
   // Find the next valid number 
   b .atoi_partial_advance // Skip to next character without processing

.atoi_partial_advance:
    add x2, x2, 1           // Increment index
    b .atoi_partial_loop    // Repeat the loop

.atoi_partial_end:
    cmp x7, 1
    beq .atoi_partial_done  // If a digit was read, we are done
    mov x4, x3              // Move the accumulated result to x0

.atoi_partial_done:
    mov x0, x4              // Move final result to x0 (return value)
    mov x30, x29            // Restore link register from frame pointer
    ret                      // Return from function
